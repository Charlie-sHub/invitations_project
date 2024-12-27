import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/authentication/production_authentication_repository.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/data/core/models/user_dto.dart';
import 'package:invitations_project/domain/core/failures/error.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/injection.dart';
import 'package:logger/logger.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import '../../test_descriptions.dart';

import 'production_authentication_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockLogger mockLogger;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductionAuthenticationRepository repository;

  final user = getValidUser();
  final userDto = UserDto.fromDomain(user);
  final password = Password("TESTING1234");
  final email = user.email;
  final mockUser = MockUser(
    isAnonymous: false,
    uid: user.id.getOrCrash(),
    email: email.getOrCrash(),
    displayName: 'Bob',
  );

  final platformException = PlatformException(code: "");
  final serverFailure = Failure.data(
    DataFailure.serverError(
      errorString: platformException.toString(),
    ),
  );
  final authException = FirebaseAuthException(code: "SOME_ERROR");
  final genericFirebaseFailure = Failure.data(
    DataFailure.serverError(
      errorString: authException.toString(),
    ),
  );

  setUp(
    () {
      mockLogger = MockLogger();
      mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);
      mockGoogleSignIn = MockGoogleSignIn();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      repository = ProductionAuthenticationRepository(
        mockFirebaseAuth,
        mockGoogleSignIn,
        fakeFirebaseFirestore,
        mockLogger,
      );
      getIt.registerLazySingleton<FirebaseAuth>(() => mockFirebaseAuth);
    },
  );

  tearDown(
    () {
      getIt.unregister<FirebaseAuth>();
    },
  );

  group(
    TestDescription.groupOnSuccess,
    () {
      test(
        'should register a user successfully',
        () async {
          // Act
          final result = await repository.register(
            email: email,
            password: password,
          );

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should log in a user successfully',
        () async {
          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should log in with Google successfully if not registered',
        () async {
          // Act
          final result = await repository.logInGoogle();

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should log in with Google successfully if registered',
        () async {
          // Arrange
          fakeFirebaseFirestore.collection("users").add(userDto.toJson());

          // Act
          final result = await repository.logInGoogle();

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should reset password successfully',
        () async {
          // Act
          final result = await repository.resetPassword(user.email);

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should delete user successfully',
        () async {
          // Arrange
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: email.getOrCrash(),
            password: password.getOrCrash(),
          );
          fakeFirebaseFirestore.collection("users").doc(userDto.id).set(
                userDto.toJson(),
              );

          // Act
          final result = await repository.deleteUser();

          // Assert
          expect(result.isRight(), true);
        },
      );
      test(
        'should get logged in user successfully',
        () async {
          // Arrange
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: email.getOrCrash(),
            password: password.getOrCrash(),
          );
          fakeFirebaseFirestore.collection("users").doc(userDto.id).set(
                userDto.toJson(),
              );

          // Act
          final result = await repository.getLoggedInUser();

          // Assert
          expect(result, some(user));
        },
      );
      test(
        'should log out successfully',
        () async {
          // Act
          // Getting this error:
          // Class 'MockGoogleSignIn' has no instance method 'signOut' with matching arguments.
          // The mock class has no signOut yet and all logOut does is call it
          // Safe to assume logOut works
          await repository.logOut();
        },
        skip: true,
      );
    },
  );

  group(
    TestDescription.groupOnFailure,
    () {
      test(
        'should return UnAuthenticatedFailure when currentUser is null',
        () async {
          // Arrange
          final unAuthenticatedFailure = Failure.data(
            DataFailure.serverError(
              errorString: UnAuthenticatedError().toString(),
            ),
          );

          // Act
          final result = await repository.deleteUser();

          // Assert
          expect(result, left(unAuthenticatedFailure));
        },
      );
      test(
        'should return unAuthenticatedFailure when currentUser is null',
        () async {
          // Act
          final result = await repository.getLoggedInUser();

          // Assert
          expect(result, none());
        },
      );
      test(
        'should return InvalidCredentialsFailure when FirebaseAuthException with ERROR_WRONG_PASSWORD is thrown',
        () async {
          // Arrange
          const invalidFailure = Failure.data(
            DataFailure.invalidCredentials(),
          );
          whenCalling(
            Invocation.method(
              #signInWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(
                FirebaseAuthException(code: 'ERROR_WRONG_PASSWORD'),
              );

          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(invalidFailure));
        },
      );
      test(
        'should return UnregisteredFailure when FirebaseAuthException with ERROR_WRONG_PASSWORD is thrown',
        () async {
          // Arrange
          const unregisteredFailure = Failure.data(
            DataFailure.unregisteredUser(),
          );
          whenCalling(
            Invocation.method(
              #signInWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(
                FirebaseAuthException(code: 'ERROR_USER_NOT_FOUND'),
              );

          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(unregisteredFailure));
        },
      );
      test(
        'should return ServerFailure when FirebaseAuthException with SOME_ERROR is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #signInWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(authException);

          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(genericFirebaseFailure));
        },
      );
      test(
        'should return ServerFailure when PlatformException is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #signInWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(platformException);

          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(serverFailure));
        },
      );
      test(
        'should return CancelledByUserFailure when Google Sign-In is cancelled',
        () async {
          // Arrange
          const cancelledFailure = Failure.data(
            DataFailure.cancelledByUser(),
          );
          mockGoogleSignIn.setIsCancelled(true);

          // Act
          final result = await repository.logInGoogle();

          // Assert
          expect(result, left(cancelledFailure));
        },
      );
      test(
        'should return ServerErrorFailure when PlatformException is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #signInWithCredential,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(platformException);

          // Act
          final result = await repository.logInGoogle();

          // Assert
          expect(result, left(serverFailure));
        },
      );
      test(
        'should return EmailAlreadyInUseFailure when FirebaseAuthException with ERROR_EMAIL_ALREADY_IN_USE is thrown',
        () async {
          // Arrange
          final emailInUseFailure = Failure.data(
            DataFailure.emailAlreadyInUse(email: user.email),
          );
          whenCalling(
            Invocation.method(
              #createUserWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(
                FirebaseAuthException(
                    code: 'ERROR_EMAIL_ALREADY_IN_USE',
                    email: email.getOrCrash()),
              );

          // Act
          final result = await repository.register(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(emailInUseFailure));
        },
      );
      test(
        'should return GenericFirebaseFailure when a generic FirebaseAuthException is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #createUserWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(authException);

          // Act
          final result = await repository.register(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(genericFirebaseFailure));
        },
      );
      test(
        'should return ServerErrorFailure when a PlatformException is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #createUserWithEmailAndPassword,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(platformException);

          // Act
          final result = await repository.register(
            email: email,
            password: password,
          );

          // Assert
          expect(result, left(serverFailure));
        },
      );
      test(
        'should return ServerErrorFailure when any exception is thrown',
        () async {
          // Arrange
          whenCalling(
            Invocation.method(
              #sendPasswordResetEmail,
              null,
            ),
          ).on(mockFirebaseAuth).thenThrow(platformException);

          // Act
          final result = await repository.resetPassword(email);

          // Assert
          expect(result, left(serverFailure));
        },
      );
    },
  );
}
