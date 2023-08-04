import 'package:bloc_by_wckd/string.dart' show enterYourEmailHere;
import 'package:flutter/material.dart';

class EmailTextfield extends StatelessWidget {
  final TextEditingController emailController;
  const EmailTextfield({super.key, required this.emailController,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
        
      ),
    );
  }
}
