import 'package:bloc_by_wckd/dialog/generic_dialog.dart';
import 'package:bloc_by_wckd/string.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = Function(String email, String password);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionBuilder: () => {ok: true},
          );
        } else {
          onLoginTapped(
            email,
            password,
          );
        }
      },
      child: const Text(login),
    );
  }
}


