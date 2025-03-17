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
  Widget build(BuildContext context) => option.fold(
        SizedBox.new,
        (either) => either.fold(
          (failure) => failure.maybeWhen(
            data: (dataFailure) => dataFailure.maybeWhen(
              invalidCredentials: () => const Text('Credenciales invalidas'),
              unregisteredUser: () => const Text('No estas registrado, '
                  'te quieres registrar?'),
              orElse: () => const Text('Error al iniciar session'),
            ),
            orElse: () => const Text('Error al iniciar session'),
          ),
          (_) => const SizedBox(),
        ),
      );
}
