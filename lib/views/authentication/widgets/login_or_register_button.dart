import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';
import 'package:invitations_project/views/authentication/widgets/login_form_action.dart';

class LoginOrRegisterButton extends StatelessWidget {
  const LoginOrRegisterButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LogInFormBloc, LogInFormState>(
        builder: (context, state) => state.failureOrSuccessOption.fold(
          () => const LoginFormAction(
            event: LogInFormEvent.loggedIn(),
            text: 'Login',
          ),
          (either) => either.fold(
            (failure) => failure.maybeWhen(
              data: (dataFailure) => dataFailure.maybeWhen(
                unregisteredUser: () => const LoginFormAction(
                  event: LogInFormEvent.registered(),
                  text: 'Registrate',
                ),
                orElse: SizedBox.new,
              ),
              orElse: SizedBox.new,
            ),
            (_) => const SizedBox(),
          ),
        ),
      );
}
