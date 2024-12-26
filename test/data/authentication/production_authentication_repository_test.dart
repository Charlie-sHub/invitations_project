import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/authentication/production_authentication_repository.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/data/core/models/user_dto.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' ;
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import '../../test_descriptions.dart';

import 'production_authentication_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<UserCredential>(),
  MockSpec<DocumentReference>(),
  MockSpec<CollectionReference>(),
])
void main() {
  late MockLogger mockLogger;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductionAuthenticationRepository repository;

  final user = getValidUser();
  final password = Password("TESTING1234");
  final email = user.email;
  final mockUser =  MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final mockUserCredential = MockUserCredential();
  final userDto = UserDto.fromDomain(user);
  final serverFailure = Failure.data(
    DataFailure.serverError(errorString: ""),
  );
  const cancelledFailure = Failure.data(
    DataFailure.cancelledByUser(),
  );
  const unregisteredFailure = Failure.data(
    DataFailure.unregisteredUser(),
  );
  const invalidFailure = Failure.data(
    DataFailure.invalidCredentials(),
  );
  final emailInUseFailure = Failure.data(
    DataFailure.emailAlreadyInUse(email: user.email),
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
    },
  );

  group(
    TestDescription.groupOnSuccess,
    () {
      test(
        'should register a user successfully',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email.getOrCrash(),
              password: password.getOrCrash(),
            ),
          ).thenAnswer((_) async => mockUserCredential);
          when(mockFirebaseAuth.currentUser).thenReturn(MockUser());

          // Act
          final result = await repository.register(
            email: email,
            password: password,
          );

          // Assert
          expect(result.isRight(), true);
          verify(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email.getOrCrash(),
              password: password.getOrCrash(),
            ),
          ).called(1);
        },
      );

      test(
        'should log in a user successfully',
        () async {
          // Arrange
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: email.getOrCrash(),
              password: password.getOrCrash(),
            ),
          ).thenAnswer((_) async => Future.value(MockUserCredential()));

          // Act
          final result = await repository.logIn(
            email: email,
            password: password,
          );

          // Assert
          expect(result.isRight(), true);
          verify(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: email.getOrCrash(),
              password: password.getOrCrash(),
            ),
          ).called(1);
        },
      );

      test(
        'should log in with Google successfully',
        () async {
          // Arrange
          when(
            mockGoogleSignIn.signIn(),
          ).thenAnswer((_) async => MockGoogleSignInAccount());
          when(
            mockGoogleSignIn.signIn().then((value) => value!.authentication),
          ).thenAnswer((_) async => MockGoogleSignInAuthentication());
          when(
            mockFirebaseAuth.signInWithCredential(any),
          ).thenAnswer((_) async => Future.value(MockUserCredential()));

          // Act
          final result = await repository.logInGoogle();

          // Assert
          expect(result, equals(right(none())));
          verify(mockGoogleSignIn.signIn()).called(1);
          verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
        },
      );

      /*




    test(
      'should reset password successfully',
      () async {
        // Arrange
        when(mockFirebaseAuth.sendPasswordResetEmail(email: user.email.getOrCrash()))
            .thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.resetPassword(user.email);

        // Assert
        expect(result, equals(right(unit)));
        verify(mockFirebaseAuth.sendPasswordResetEmail(email: user.email.getOrCrash())).called(1);
      },
    );

    test(
      'should delete user successfully',
      () async {
        // Arrange
        when(fakeFirebaseFirestore.currentUser()).thenAnswer((_) async => user);
        when(fakeFirebaseFirestore.userExistsInCollection(any)).thenAnswer((_) async => true);
        when(fakeFirebaseFirestore.userCollection).thenReturn(MockCollectionReference());
        when(fakeFirebaseFirestore.userCollection.doc(any)).thenReturn(MockDocumentReference());
        when(fakeFirebaseFirestore.userCollection.doc(any).delete()).thenAnswer((_) async => Future.value());
        when(mockFirebaseAuth.currentUser).thenReturn(MockUser());
        when(mockFirebaseAuth.currentUser!.delete()).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.deleteUser();

        // Assert
        expect(result, equals(right(unit)));
        verify(fakeFirebaseFirestore.userCollection.doc(any).delete()).called(1);
        verify(mockFirebaseAuth.currentUser!.delete()).called(1);
      },
    );

    test(
      'should get logged in user successfully',
      () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(MockUser());
        when(fakeFirebaseFirestore.currentUser()).thenAnswer((_) async => user);

        // Act
        final result = await repository.getLoggedInUser();

        // Assert
        expect(result, equals(some(user)));
        verify(mockFirebaseAuth.currentUser).called(1);
        verify(fakeFirebaseFirestore.currentUser()).called(1);
      },
    );

    test(
      'should log out successfully',
      () async {
        // Arrange
        when(mockGoogleSignIn.signOut()).thenAnswer((_) async => Future.value());
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => Future.value());

        // Act
        await repository.logOut();

        // Assert
        verify(mockGoogleSignIn.signOut()).called(1);
        verify(mockFirebaseAuth.signOut()).called(1);
      },
    );
       */
    },
  );

  group(
    TestDescription.groupOnFailure,
    () {},
  );
}
