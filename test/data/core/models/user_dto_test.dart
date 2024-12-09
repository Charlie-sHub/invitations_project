import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/data/core/models/user_dto.dart';
import '../../../test_descriptions.dart';

void main() {
  test(
    TestDescription.shouldEqualEntity,
        () async {
      // Arrange
      final user = getValidUser();
      // Act
      final userDto = UserDto.fromDomain(user);
      final result = userDto.toDomain();
      // Assert
      expect(result, user);
    },
  );
}
