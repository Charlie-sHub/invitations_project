import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/get_valid_user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';

import '../../../test_descriptions.dart';

void main() {
  final validUser = getValidUser();
  final invalidPasswordUser = validUser.copyWith(password: Password(""));
  final invalidEmailAddressUser = validUser.copyWith(email: EmailAddress(""));
  final invalidLastLoginUser = validUser.copyWith(
    lastLogin: PastDate(DateTime.now().add(const Duration(days: 10))),
  );
  final invalidCreationDateUser = validUser.copyWith(
    creationDate: PastDate(DateTime.now().add(const Duration(days: 10))),
  );
  test(
    TestDescription.valid,
    () async {
      // Assert
      expect(validUser.isValid, true);
    },
  );
  group(
    TestDescription.groupOnFailure,
    () {
      test(
        "${TestDescription.invalid} with invalidPasswordUser",
        () async {
          // Assert
          expect(invalidPasswordUser.isValid, false);
        },
      );
      test(
        "${TestDescription.invalid} with invalidEmailAddressUser",
        () async {
          // Assert
          expect(invalidEmailAddressUser.isValid, false);
        },
      );
      test(
        "${TestDescription.invalid} with invalidLastLoginUser",
        () async {
          // Assert
          expect(invalidLastLoginUser.isValid, false);
        },
      );
      test(
        "${TestDescription.invalid} with invalidCreationDateUser",
        () async {
          // Assert
          expect(invalidCreationDateUser.isValid, false);
        },
      );
    },
  );
}
