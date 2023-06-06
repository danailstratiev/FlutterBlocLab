import 'package:flutter/material.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/dialogs/generic_dialog.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/strings.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

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
            showGenericDialog(
              context: context,
              title: emailOrPasswordEmptyDialogTitle,
              content: emailOrPasswordEmptyDescription,
              optionsBuilder: () => {
                ok: true,
              },
            );
          } else {
            onLoginTapped(
              email,
              password,
            );
          }
        },
        child: const Text(login));
  }
}
