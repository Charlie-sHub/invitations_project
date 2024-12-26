import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';

/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: AuthenticationRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentAuthenticationRepository
    implements AuthenticationRepositoryInterface {
  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    return right(unit);
  }

  @override
  Future<Option<User>> getLoggedInUser() async {
    return some(getValidUser());
  }

  @override
  Future<Either<Failure, Unit>> logIn({
    required EmailAddress email,
    required Password password,
  }) async {
    return right(unit);
  }

  @override
  Future<Either<Failure, Option<User>>> logInApple() async {
    return right(some(getValidUser()));
  }

  @override
  Future<Either<Failure, Option<User>>> logInGoogle() async {
    return right(some(getValidUser()));
  }

  @override
  Future<void> logOut() async {}

  @override
  Future<Either<Failure, Unit>> register({
    required EmailAddress email,
    required Password password,
  }) async {
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress) async {
    return right(unit);
  }
}
