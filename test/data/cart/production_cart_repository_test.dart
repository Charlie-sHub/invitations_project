import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/cart/production_cart_repository.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/cloud_storage/cloud_storage_service.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:logger/logger.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_descriptions.dart';
import 'production_cart_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<CloudStorageService>(),
])
void main() {
  late MockLogger mockLogger;
  late MockCloudStorageService mockCloudStorage;
  late FakeFirebaseFirestore fakeFirestore;
  late ProductionCartRepository repository;

  final invitation = getValidInvitation();
  final invitationId = invitation.id.getOrCrash();

  setUp(
    () {
      mockLogger = MockLogger();
      mockCloudStorage = MockCloudStorageService();
      fakeFirestore = FakeFirebaseFirestore();
      repository = ProductionCartRepository(
        mockLogger,
        fakeFirestore,
        mockCloudStorage,
      );
    },
  );

  group(
    TestDescription.groupOnSuccess,
    () {
      test(
        'should save an invitation successfully',
        () async {
          // Arrange

          // Act
          final result = await repository.saveInvitation(invitation);
          final invitationDoc =
              await fakeFirestore.invitationCollection.doc(invitationId).get();

          // Assert
          expect(result.isRight(), true);
          expect(invitationDoc.exists, true);
        },
      );

      test(
        'should delete an invitation successfully',
        () async {
          // Arrange
          final doc = fakeFirestore.invitationCollection.doc(invitationId);
          await doc.set(InvitationDto.fromDomain(invitation));

          // Act
          final result = await repository.deleteInvitation(invitation.id);

          // Assert
          expect(result.isRight(), true);
          final invitationDoc = await doc.get();
          expect(invitationDoc.exists, false);
        },
      );

      // TODO: Update when purchase has been properly implemented
      test(
        'should return right(unit) when purchase is successful',
        () async {
          // Act
          final result = await repository.purchase();

          // Assert
          expect(result, right(unit));
        },
      );
    },
  );

  group(
    TestDescription.groupOnFailure,
    skip: true,
    () {
      test(
        'should return a DataFailure on FirebaseException',
        () async {
          // Arrange
          final doc = fakeFirestore.invitationCollection.doc(invitationId);
          // This is the way to throw exceptions according to FakeFirebaseFirestore documentation
          // But it's not working here and so the result is right
          whenCalling(Invocation.method(#set, null))
              .on(doc)
              .thenThrow(FirebaseException(plugin: 'firestore'));

          // Act
          final result = await repository.saveInvitation(invitation);

          // Assert
          expect(result.isLeft(), true);
          verify(mockLogger.e(any)).called(1);
        },
      );

      test(
        'should return a DataFailure on FirebaseException',
        () async {
          // Arrange
          final doc = fakeFirestore.invitationCollection.doc(invitationId);
          // This is the way to throw exceptions according to FakeFirebaseFirestore documentation
          // But it's not working here and so the result is right
          whenCalling(Invocation.method(#delete, null))
              .on(doc)
              .thenThrow(FirebaseException(plugin: 'firestore'));

          // Act
          final result = await repository.deleteInvitation(invitation.id);

          // Assert
          expect(result.isLeft(), true);
          verify(mockLogger.e(any)).called(1);
        },
      );

      // TODO: Update when purchase has been properly implemented
      test(
        'should return a DataFailure on error',
        () async {
          // Act
          final result = await repository.purchase();

          // Assert
          expect(result.isLeft(), true);
          expect(result.leftMap((failure) => failure is DataFailure), true);
          verify(mockLogger.e(any)).called(1);
        },
      );
    },
  );
}
