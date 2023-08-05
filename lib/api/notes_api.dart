import 'package:bloc_by_wckd/model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Notes>?> getNotes({
    required LoginHandler loginHandler,
  });
}

// If the token is correct it will return the mockeNotes
class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Notes>?> getNotes({required LoginHandler loginHandler}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandler == const LoginHandler.foobar() ? mockedNotes : null,
      );
}
