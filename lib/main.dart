// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer' as devtools show log;
import 'package:bloc_by_wckd/api/login_api.dart';
import 'package:bloc_by_wckd/api/notes_api.dart';
import 'package:bloc_by_wckd/bloc/app_bloc.dart';
import 'package:bloc_by_wckd/bloc/bloc_action.dart';
import 'package:bloc_by_wckd/bloc/bloc_state.dart';
import 'package:bloc_by_wckd/dialog/generic_dialog.dart';
import 'package:bloc_by_wckd/dialog/loading_screen.dart';
import 'package:bloc_by_wckd/model.dart';
import 'package:bloc_by_wckd/string.dart';
import 'package:bloc_by_wckd/view/iterable_to_listview.dart';
import 'package:bloc_by_wckd/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: const Text('Bloc'),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // on loading
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Please wait',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // on login error
            final loginError = appState.loginErrors;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }
            // if we are logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                loginError == null &&
                appState.loginHandler == const LoginHandler.foobar() &&
                appState.notes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.notes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
