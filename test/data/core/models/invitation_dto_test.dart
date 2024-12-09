import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import '../../../test_descriptions.dart';

void main() {
  test(
    TestDescription.shouldEqualEntity,
    () async {
      // Arrange
      final invitation = getValidInvitation();
      // Act
      final invitationDto = InvitationDto.fromDomain(invitation);
      final result = invitationDto.toDomain();
      // Assert
      expect(result, invitation);
    },
  );
}
