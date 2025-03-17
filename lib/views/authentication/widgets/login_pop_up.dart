import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/views/authentication/widgets/login_form.dart';
import 'package:invitations_project/views/authentication/widgets/login_or_register_button.dart';

class LoginPopUp extends StatelessWidget {
  const LoginPopUp({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: const Center(
        child: Text('Login'),
      ),
      content: const LoginForm(),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () => context.router.maybePop(),
          child: const Text('Cancelar'),
        ),
        const LoginOrRegisterButton(),
      ],
    );
}

/*

 */
