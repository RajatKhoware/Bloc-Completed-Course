import 'package:bloc_by_wckd/string.dart' show enterYourEmailHere;
import 'package:flutter/material.dart';

class PasswordTextfield extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordTextfield({
    super.key,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      autocorrect: false,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
