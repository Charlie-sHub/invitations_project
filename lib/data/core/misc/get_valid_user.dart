import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

User getValidUser() {
  return User(
    id: UniqueId(),
    email: EmailAddress("test@test.test"),
    password: Password("abcd*1234"),
    invitationsIds: <UniqueId>{},
    lastLogin: PastDate(DateTime.now()),
    creationDate: PastDate(
      DateTime.now().subtract(const Duration(days: 100)),
    ),
  );
}
