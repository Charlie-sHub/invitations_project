import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/get_valid_user.dart';

import '../../test_descriptions.dart';

void main() {
  test(
    TestDescription.valid,
    () async {
      // Arrange
      final validUser = getValidUser();
      // Assert
      expect(validUser.isValid, true);
    },
  );
}
