import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';

class LoginFormAction extends StatelessWidget {
  const LoginFormAction({
    required this.text,
    required this.event,
    super.key,
  });

  final String text;
  final LogInFormEvent event;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<LogInFormBloc>().add(event);
        context.read<AuthenticationBloc>().add(
              AuthenticationEvent.authenticationCheckRequested(),
            );
      },
      child: Text(text),
    );
  }
}
