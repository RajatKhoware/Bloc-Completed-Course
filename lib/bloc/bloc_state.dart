// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart' show immutable;
import 'package:bloc_by_wckd/model.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandler? loginHandler;
  final Iterable<Notes>? notes;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandler,
    required this.notes,
  });

  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandler = null,
        notes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginErrors': loginErrors,
        'loginHandler': loginHandler,
        'notes': notes,
      }.toString();
}
