import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/models/user_dto.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart' as entity;
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:logger/logger.dart';

@LazySingleton(
  as: AuthenticationRepositoryInterface,
  env: [Environment.prod],
)
class ProductionAuthenticationRepository
    implements AuthenticationRepositoryInterface {
  final Logger _logger;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  ProductionAuthenticationRepository(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
    this._logger,
  );

  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    try {
      final user = await _firestore.currentUser();
      final userIsRegistered = await _firestore.userExistsInCollection(
        user.email.getOrCrash(),
      );
      if (userIsRegistered) {
        await _firestore.userCollection.doc(user.id.getOrCrash()).delete();
      }
      await _firebaseAuth.currentUser?.delete();
      return right(unit);
    } catch (exception) {
      return left(
        Failure.data(
          DataFailure.serverError(errorString: exception.toString()),
        ),
      );
    }
  }

  @override
  Future<Option<entity.User>> getLoggedInUser() async {
    try {
      final user = await _firestore.currentUser();
      return some(user);
    } catch (exception) {
      _logger.e("Error getting the logged in user: $exception");
      return none();
    }
  }

  @override
  Future<Either<Failure, Unit>> logIn({
    required EmailAddress email,
    required Password password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.getOrCrash(),
        password: password.getOrCrash(),
      );
      return right(unit);
    } on FirebaseAuthException catch (exception) {
      if (exception.code == "ERROR_WRONG_PASSWORD") {
        return left(
          const Failure.data(
            DataFailure.invalidCredentials(),
          ),
        );
      } else if (exception.code == "ERROR_USER_NOT_FOUND") {
        return left(
          const Failure.data(
            DataFailure.unregisteredUser(),
          ),
        );
      } else {
        _logger.e(exception.toString());
        return left(
          Failure.data(
            DataFailure.serverError(errorString: exception.toString()),
          ),
        );
      }
    } on PlatformException catch (exception) {
      _logger.e(exception.toString());
      return left(
        Failure.data(
          DataFailure.serverError(errorString: exception.toString()),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Option<entity.User>>> logInApple() async {
    // TODO: implement logInApple
    // The implementation requires an Apple Developer account
    // which is paid and for the moment not worth it
    // https://pub.dev/packages/sign_in_with_apple
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Option<entity.User>>> logInGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuthentication = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null) {
          final email = firebaseUser.email!;
          final registered = await _firestore.userExistsInCollection(email);
          if (!registered) {
            final user = entity.User.empty().copyWith(
              email: EmailAddress(email),
              invitationsIds: {},
              lastLogin: PastDate(DateTime.now()),
              creationDate: PastDate(DateTime.now()),
            );
            await _firestore.userCollection.doc(user.id.getOrCrash()).set(
                  UserDto.fromDomain(user),
                );
          }
          return right(none());
        } else {
          // In principle this should never happen as _firebaseAuth signs in immediately after google
          return left(
            const Failure.data(
              DataFailure.serverError(errorString: "Null Firebase user"),
            ),
          );
        }
      } else {
        return left(
          const Failure.data(
            DataFailure.cancelledByUser(),
          ),
        );
      }
    } on FirebaseAuthException catch (_) {
      return left(
        const Failure.data(
          DataFailure.cancelledByUser(),
        ),
      );
    } on PlatformException catch (exception) {
      _logger.e(exception.toString());
      return left(
        Failure.data(
          DataFailure.serverError(errorString: exception.toString()),
        ),
      );
    }
  }

  @override
  Future<void> logOut() async => Future.wait(
        [
          _googleSignIn.signOut(),
          _firebaseAuth.signOut(),
        ],
      );

  @override
  Future<Either<Failure, Unit>> register({
    required EmailAddress email,
    required Password password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.getOrCrash(),
        password: password.getOrCrash(),
      );
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        final user = entity.User(
          id: UniqueId.fromUniqueString(firebaseUser.uid),
          email: email,
          invitationsIds: {},
          lastLogin: PastDate(DateTime.now()),
          creationDate: PastDate(DateTime.now()),
        );
        await _firestore.userCollection.doc(firebaseUser.uid).set(
              UserDto.fromDomain(user),
            );
        return right(unit);
      } else {
        // In principle this should never happen as _firebaseAuth would have
        // thrown an exception when calling createUserWithEmailAndPassword
        return left(
          const Failure.data(
            DataFailure.serverError(errorString: "Null Firebase user"),
          ),
        );
      }
    } on FirebaseAuthException catch (exception) {
      if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        return left(
          Failure.data(
            DataFailure.emailAlreadyInUse(
              email: EmailAddress(exception.email!),
            ),
          ),
        );
      } else {
        _logger.e(exception.toString());
        return left(
          Failure.data(
            DataFailure.serverError(errorString: exception.toString()),
          ),
        );
      }
    } on PlatformException catch (exception) {
      _logger.e(exception.toString());
      return left(
        Failure.data(
          DataFailure.serverError(errorString: exception.toString()),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: emailAddress.getOrCrash(),
      );
      return right(unit);
    } catch (exception) {
      _logger.e(exception.toString());
      return left(
        Failure.data(
          DataFailure.serverError(errorString: exception.toString()),
        ),
      );
    }
  }
}
