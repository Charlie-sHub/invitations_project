import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/data/home/production_home_repository.dart';
import 'package:logger/logger.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'production_home_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockLogger mockLogger;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductionHomeRepository repository;

  final invitations = [
    getValidInvitation(),
    getValidInvitation(),
  ];

  setUp(
    () {
      mockLogger = MockLogger();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      repository = ProductionHomeRepository(
        mockLogger,
        fakeFirebaseFirestore,
      );
    },
  );

  test(
    'should return a list of example invitations when there are some',
    () async {
      // Arrange
      for (final invitation in invitations) {
        final dto = InvitationDto.fromDomain(invitation);
        await fakeFirebaseFirestore.invitationCollection.doc(dto.id).set(dto);
      }

      // Act
      final result = await repository.getExampleInvitations();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), invitations);
    },
  );

  test(
    'should return an empty list when there are no example invitations',
    () async {
      // Act
      final result = await repository.getExampleInvitations();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), []);
    },
  );

  test(
    'should return a DataFailure on FirebaseException',
    skip: true,
    () async {
      final collection = fakeFirebaseFirestore.invitationCollection;
      // This is the way to throw exceptions according to FakeFirebaseFirestore documentation
      // But it's not working here and so the result is right
      whenCalling(
        Invocation.method(
          #get,
          null,
        ),
      ).on(collection).thenThrow(
            FirebaseException(plugin: 'firestore'),
          );

      // Act
      final result = await repository.getExampleInvitations();

      // Assert
      expect(result.isLeft(), true);
      verify(mockLogger.e(any)).called(1);
    },
  );
}
