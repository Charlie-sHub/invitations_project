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
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:logger/logger.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

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
    'saveInvitation',
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
        'should return a DataFailure on FirebaseException',
        () async {
          // Arrange
          final doc = fakeFirestore.collection("invitations").doc(invitationId);
          whenCalling(
            Invocation.method(
              #set,
              null,
            ),
          ).on(doc).thenThrow(
                FirebaseException(plugin: 'firestore'),
              );

          // Act
          final result = await repository.saveInvitation(invitation);

          // Assert
          expect(result.isLeft(), true);
          expect(result.leftMap((failure) => failure is DataFailure), true);
          verify(mockLogger.e(any)).called(1);
        },
      );
    },
  );

  group(
    'deleteInvitation',
    () {
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

      test(
        'should return a DataFailure on FirebaseException',
        () async {
          // Arrange
          final doc = fakeFirestore.collection("invitations").doc(invitationId);
          whenCalling(
            Invocation.method(
              #delete,
              null,
            ),
          ).on(doc).thenThrow(
                FirebaseException(plugin: 'firestore'),
              );

          // Act
          final result = await repository.deleteInvitation(invitation.id);

          // Assert
          expect(result.isLeft(), true);
          expect(result.leftMap((failure) => failure is DataFailure), true);
          verify(mockLogger.e(any)).called(1);
        },
      );
    },
  );

  // TODO: Update when purchase has been properly implemented
  group(
    'purchase',
    skip: true,
    () {
      test(
        'should return right(unit) when purchase is successful',
        () async {
          // Act
          final result = await repository.purchase();

          // Assert
          expect(result, right(unit));
        },
      );

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
