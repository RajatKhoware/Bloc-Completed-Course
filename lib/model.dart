// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandler {
  final String token;

  const LoginHandler({
    required this.token,
  });

  const LoginHandler.foobar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandler other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'Login (token = $token)';
}

enum LoginErrors { invalidHandle }

@immutable
class Notes {
  final String title;

  const Notes({
    required this.title,
  });

  @override
  String toString() => 'Notes (title = $title)';
}

final mockedNotes = Iterable.generate(
  3,
  (i) => Notes(title: 'Note ${i + 1}'),
);
