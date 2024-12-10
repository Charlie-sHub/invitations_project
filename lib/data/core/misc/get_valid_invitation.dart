import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

Invitation getValidInvitation() {
  return Invitation(
    id: UniqueId(),
    creatorId: UniqueId(),
    title: Title("valid invitation title"),
    type: InvitationType.example,
    eventDate: FutureDate(
      DateTime.now().add(const Duration(days: 100)),
    ),
    lastModificationDate: PastDate(
      DateTime.now().subtract(const Duration(days: 100)),
    ),
    creationDate: PastDate(
      DateTime.now().subtract(const Duration(days: 100)),
    ),
  );
}
