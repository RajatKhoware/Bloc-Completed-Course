// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:bloc_by_wckd/bloc/bloc_action.dart';
import 'package:bloc_by_wckd/model.dart';

import 'package:bloc_by_wckd/api/login_api.dart';
import 'package:bloc_by_wckd/api/notes_api.dart';
import 'package:bloc_by_wckd/bloc/bloc_state.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandler acceptedHandler;
  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptedHandler,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // start loading
        emit(
          const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandler: null,
            notes: null,
          ),
        );
        // loggin the user in
        final loginHandler = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        // can be error state or logged-in state
        emit(
          AppState(
            isLoading: false,
            loginErrors: loginHandler != acceptedHandler
                ? LoginErrors.invalidHandle
                : null,
            loginHandler: loginHandler,
            notes: null,
          ),
        );
      },
    );
    on<LoadNotesAction>((event, emit) async {
      // start loading
      emit(
        AppState(
          isLoading: true,
          loginErrors: null,
          loginHandler: state.loginHandler,
          notes: null,
        ),
      );
      // get login handler
      final loginHandler = state.loginHandler;
      // token verification
      if (loginHandler != acceptedHandler) {
        // invalid login Error
        emit(
          AppState(
            isLoading: false,
            loginErrors: LoginErrors.invalidHandle,
            loginHandler: loginHandler,
            notes: null,
          ),
        );
        return;
      }
      // valid login, now fetch notes
      final notesHandler = await notesApi.getNotes(loginHandler: loginHandler!);
      emit(
        AppState(
          isLoading: false,
          loginErrors: null,
          loginHandler: state.loginHandler,
          notes: notesHandler,
        ),
      );
    });
  }
}
