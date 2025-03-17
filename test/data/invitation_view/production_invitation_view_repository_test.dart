import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/data/invitation_view/production_invitation_edition_repository.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:logger/logger.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';

import 'production_invitation_view_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockLogger mockLogger;
  late FakeFirebaseFirestore fakeFirestore;
  late ProductionInvitationViewRepository repository;

  const notFoundFailure = Failure.data(
    DataFailure.notFoundError(),
  );

  const serverFailure = Failure.data(
    DataFailure.serverError(errorString: 'Firebase error: null'),
  );

  setUp(
    () {
      mockLogger = MockLogger();
      fakeFirestore = FakeFirebaseFirestore();
      repository = ProductionInvitationViewRepository(
        mockLogger,
        fakeFirestore,
      );
    },
  );

  test(
    'should return an invitation when it exists',
    () async {
      // Arrange
      final invitation = getValidInvitation();
      final invitationDto = InvitationDto.fromDomain(invitation);
      await fakeFirestore.invitationCollection.doc(invitationDto.id).set(
            invitationDto,
          );

      // Act
      final result = await repository.loadInvitation(invitation.id);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(Invitation.empty), invitation);
    },
  );

  test(
    'should return a NotFoundError when the invitation does not exist',
    () async {
      // Arrange
      final invitationId = UniqueId.fromUniqueString('nonexistentId');

      // Act
      final result = await repository.loadInvitation(invitationId);
      final resultFailure = result.fold(
        (failure) => failure,
        (_) => null,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(resultFailure, notFoundFailure);
    },
  );

  test(
    'should return a DataFailure on FirebaseException',
    () async {
      // Arrange
      final invitationId = UniqueId.fromUniqueString('errorId');
      final doc = fakeFirestore.invitationCollection.doc(
        invitationId.getOrCrash(),
      );
      whenCalling(
        Invocation.method(#get, []),
      ).on(doc).thenThrow(
            FirebaseException(plugin: 'firestore'),
          );

      // Act
      final result = await repository.loadInvitation(invitationId);
      final resultFailure = result.fold(
        (failure) => failure,
        (_) => null,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(resultFailure, serverFailure);
    },
  );
}
