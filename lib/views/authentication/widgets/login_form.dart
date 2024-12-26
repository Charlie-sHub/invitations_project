import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/authentication/widgets/email_text_field.dart';
import 'package:invitations_project/views/authentication/widgets/log_in_google_button.dart';
import 'package:invitations_project/views/authentication/widgets/login_failure_message.dart';
import 'package:invitations_project/views/authentication/widgets/password_text_field.dart';
import 'package:logger/logger.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogInFormBloc, LogInFormState>(
      listenWhen: (previous, current) =>
          previous.failureOrSuccessOption != current.failureOrSuccessOption ||
          current.thirdPartyUserOption.isSome(),
      listener: _listener,
      builder: (context, state) => Form(
        autovalidateMode: state.showErrorMessages
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            EmailTextField(
              validator: (_) => _emailValidator(state),
              eventToAdd: (String value) => context.read<LogInFormBloc>().add(
                    LogInFormEvent.emailChanged(value),
                  ),
            ),
            const SizedBox(height: 16),
            PasswordTextField(
              eventToAdd: (String value) => context.read<LogInFormBloc>().add(
                    LogInFormEvent.passwordChanged(value),
                  ),
              validator: (_) => _passwordValidator(state),
            ),
            LoginFailureMessage(option: state.failureOrSuccessOption),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LogInGoogleButton(),
                // Apple log in will be ignored for the time being
                // LogInAppleButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? _emailValidator(LogInFormState state) => state.email.value.fold(
        (failure) => failure.maybeMap(
          invalidEmail: (_) => "Email invalido",
          orElse: () => "Error desconocido",
        ),
        (_) => "",
      );

  String? _passwordValidator(LogInFormState state) => state.password.value.fold(
        (failure) => failure.maybeMap(
          emptyString: (_) => "Contraseña vacia",
          multiLineString: (_) => "La contraseña solo debe tener una linea",
          stringExceedsLength: (_) => "La contraseña es demasiado larga",
          // Rather superfluous
          invalidPassword: (_) => "Contraseña invalida",
          orElse: () => "Error desconocido",
        ),
        (_) => "",
      );

  void _listener(BuildContext context, LogInFormState state) =>
      state.thirdPartyUserOption.fold(
        () => state.failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) => getIt<Logger>().e(
              "Error logging in: $failure",
            ),
            (_) => _onSuccess(context),
          ),
        ),
        (_) => _onSuccess(context),
      );

  void _onSuccess(BuildContext context) {
    context.router.maybePop();
    context.read<AuthenticationBloc>().add(
          const AuthenticationEvent.authenticationCheckRequested(),
        );
  }
}
