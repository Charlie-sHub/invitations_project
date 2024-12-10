import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';

@LazySingleton(
  as: AuthenticationRepositoryInterface,
  env: [Environment.prod],
)
class ProductionAuthenticationRepository
    implements AuthenticationRepositoryInterface {
  @override
  Future<void> deleteUser() {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Option<User>> getLoggedInUser() {
    // TODO: implement getLoggedInUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> logIn(User user) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Option<User>>> logInApple() {
    // TODO: implement logInApple
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Option<User>>> logInGoogle() {
    // TODO: implement logInGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> register(User user) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
