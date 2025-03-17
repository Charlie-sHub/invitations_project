import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';

import '../../../test_descriptions.dart';

void main() {
  final validInvitation = getValidInvitation();
  final invalidTitleInvitation = validInvitation.copyWith(title: Title(''));
  final invalidEventDateInvitation = validInvitation.copyWith(
    eventDate: FutureDate(DateTime.now().subtract(const Duration(days: 10))),
  );
  final invalidLastModificationDateInvitation = validInvitation.copyWith(
    creationDate: PastDate(DateTime.now().add(const Duration(days: 10))),
  );
  final invalidCreationDateInvitation = validInvitation.copyWith(
    creationDate: PastDate(DateTime.now().add(const Duration(days: 10))),
  );
  test(
    TestDescription.valid,
    () async {
      // Assert
      expect(validInvitation.isValid, true);
    },
  );
  group(
    TestDescription.groupOnFailure,
    () {
      test(
        '${TestDescription.invalid} with invalidTitleInvitation',
        () async {
          // Assert
          expect(invalidTitleInvitation.isValid, false);
        },
      );
      test(
        '${TestDescription.invalid} with invalidEventDateInvitation',
        () async {
          // Assert
          expect(invalidEventDateInvitation.isValid, false);
        },
      );
      test(
        '${TestDescription.invalid} with invalidLastModificationDateInvitation',
        () async {
          // Assert
          expect(invalidLastModificationDateInvitation.isValid, false);
        },
      );
      test(
        '${TestDescription.invalid} with invalidCreationDateInvitation',
        () async {
          // Assert
          expect(invalidCreationDateInvitation.isValid, false);
        },
      );
    },
  );
}
