import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';

class LogInGoogleButton extends StatelessWidget {
  const LogInGoogleButton({super.key});

  @override
  Widget build(BuildContext context) => GoogleAuthButton(
      style: const AuthButtonStyle(
        buttonType: AuthButtonType.icon,
      ),
      onPressed: () => context.read<LogInFormBloc>().add(
        const LogInFormEvent.loggedInGoogle(),
      ),
    );
}
