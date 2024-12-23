import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/core/error/failure.dart';

class LoginFailureMessage extends StatelessWidget {
  const LoginFailureMessage({
    required this.option,
    super.key,
  });

  final Option<Either<Failure, Unit>> option;

  @override
  Widget build(BuildContext context) {
    return option.fold(
      () => SizedBox(),
      (either) => either.fold(
        (failure) => failure.maybeWhen(
          data: (dataFailure) => dataFailure.maybeWhen(
            invalidCredentials: () => Text("Credenciales invalidas"),
            unregisteredUser: () => Text("No estas registrado, te quieres registrar?"),
            orElse: () => Text("Error al iniciar session"),
          ),
          orElse: () => Text("Error al iniciar session"),
        ),
        (_) => SizedBox(),
      ),
    );
  }
}
