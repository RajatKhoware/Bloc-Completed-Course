import 'package:bloc_by_wckd/model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandler?> login({
    required String email,
    required String password,
  });
}

class LoginApi implements LoginApiProtocol {
  @override
  Future<LoginHandler?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggedIn) => isLoggedIn ? const LoginHandler.foobar() : null);
}
