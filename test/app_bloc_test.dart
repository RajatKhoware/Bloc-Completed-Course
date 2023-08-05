// ignore_for_file: unused_import

import 'package:bloc_by_wckd/api/login_api.dart';
import 'package:bloc_by_wckd/api/notes_api.dart';
import 'package:bloc_by_wckd/bloc/app_bloc.dart';
import 'package:bloc_by_wckd/bloc/bloc_action.dart';
import 'package:bloc_by_wckd/bloc/bloc_state.dart';
import 'package:bloc_by_wckd/model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Notes> mockedNotes = [
  Notes(title: 'Note 1'),
  Notes(title: 'Note 1'),
  Notes(title: 'Note 1'),
];

@immutable
class DummyNotesApi extends NotesApiProtocol {
  final LoginHandler acceptedLoginHanlder;
  final Iterable<Notes>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHanlder,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHanlder = const LoginHandler.foobar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Notes>?> getNotes({
    required LoginHandler loginHandler,
  }) async {
    if (acceptedLoginHanlder == loginHandler) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi extends LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandler handlerToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handlerToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handlerToReturn = const LoginHandler.foobar();

  @override
  Future<LoginHandler?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handlerToReturn;
    } else {
      return null;
    }
  }
}

const acceptedLoginHandle = LoginHandler(token: 'ABC');

void main() {
  blocTest<AppBloc, AppState>(
    'Test inital state of App Bloc',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptedHandler: acceptedLoginHandle,
    ),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
    'Can we log in with correct credentials?',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'foo',
        handlerToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedHandler: acceptedLoginHandle,
    ),
    act: (appState) => appState.add(
      LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandler: null,
        notes: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: null,
        loginHandler: acceptedLoginHandle,
        notes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'We should not be able to log in with invalid credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@baz.com',
        acceptedPassword: 'foo',
        handlerToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedHandler: acceptedLoginHandle,
    ),
    act: (appState) => appState.add(
      LoginAction(
        email: 'bar@baz.com',
        password: 'bar',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandler: null,
        notes: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: LoginErrors.invalidHandle,
        loginHandler: null,
        notes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Load Notes with valid Login handler',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@baz.com',
        acceptedPassword: 'foo',
        handlerToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHanlder: acceptedLoginHandle,
        notesToReturnForAcceptedLoginHandle: mockedNotes,
      ),
      acceptedHandler: acceptedLoginHandle,
    ),
    act: (appBloc) {
      appBloc.add(
        LoginAction(
          email: 'foo@baz.com',
          password: 'foo',
        ),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandler: null,
        notes: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: null,
        loginHandler: acceptedLoginHandle,
        notes: null,
      ),
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandler: acceptedLoginHandle,
        notes: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: null,
        loginHandler: acceptedLoginHandle,
        notes: mockedNotes,
      ),
    ],
  );
}
