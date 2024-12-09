import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';

import '../../../test_descriptions.dart';

void main() {
  test(
    TestDescription.valid,
    () async {
      // Arrange
      final validInvitation = getValidInvitation();
      // Assert
      expect(validInvitation.isValid, true);
    },
  );
}
