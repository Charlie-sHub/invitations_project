import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';

/// Repository for authentication and registration of new [User]s.
abstract class AuthenticationRepositoryInterface {
  /// Sends a new [User] to be registered in the database.
  Future<Either<Failure, Unit>> register({
    required EmailAddress email,
    required Password password,
  });

  /// Sends a [User] object with only username and password
  /// to login in the server.
  Future<Either<Failure, Unit>> logIn({
    required EmailAddress email,
    required Password password,
  });

  /// Sends a request to the server
  /// to reset the password associated with the given [EmailAddress]
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress);

  /// Calls the Google sign in API to log in or register.
  Future<Either<Failure, Option<User>>> logInGoogle();

  /// Calls the Apple sign in API to log in or register.
  Future<Either<Failure, Option<User>>> logInApple();

  /// Gets the [User] currently logged in
  Future<Option<User>> getLoggedInUser();

  /// Logs out of the application
  Future<void> logOut();

  /// Deletes the user
  Future<Either<Failure, Unit>>  deleteUser();
}
