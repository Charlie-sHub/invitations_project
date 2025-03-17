import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';

import '../../../../test_descriptions.dart';

void main() {
  const invalidEmail = 'test';
  const validEmail = 'test@test.com';
  test(
    TestDescription.valid,
    () async {
      // Act
      final emailAddress = EmailAddress(validEmail);
      // Assert
      expect(emailAddress.isValid(), true);
      expect(emailAddress.getOrCrash(), validEmail);
    },
  );
  test(
    TestDescription.invalid,
    () async {
      // Act
      final emailAddress = EmailAddress(invalidEmail);
      // Assert
      expect(emailAddress.isValid(), false);
    },
  );
}
