import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/data/core/misc/server_timestamp_converter.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  const UserDto._();

  const factory UserDto({
    required String id,
    required String email,
    required Set<String> invitationsIds,
    @ServerDateStringConverter() required DateTime lastLogin,
    @ServerDateStringConverter() required DateTime creationDate,
  }) = _UserDto;

  factory UserDto.fromDomain(User user) => UserDto(
        id: user.id.getOrCrash(),
        email: user.email.getOrCrash(),
        invitationsIds: user.invitationsIds
            .map((uniqueId) => uniqueId.getOrCrash())
            .toSet(),
        lastLogin: user.lastLogin.getOrCrash(),
        creationDate: user.creationDate.getOrCrash(),
      );

  User toDomain() => User(
        id: UniqueId.fromUniqueString(id),
        email: EmailAddress(email),
        invitationsIds: invitationsIds
            .map(UniqueId.fromUniqueString)
            .toSet(),
        lastLogin: PastDate(lastLogin),
        creationDate: PastDate(creationDate),
      );
}
