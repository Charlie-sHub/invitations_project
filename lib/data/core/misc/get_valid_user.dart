import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

User getValidUser() => User(
    id: UniqueId(),
    email: EmailAddress('test@test.test'),
    invitationsIds: <UniqueId>{},
    lastLogin: PastDate(DateTime.now()),
    creationDate: PastDate(
      DateTime.now().subtract(const Duration(days: 100)),
    ),
  );
