import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/data/core/misc/server_timestamp_converter.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'invitation_dto.freezed.dart';

part 'invitation_dto.g.dart';

@freezed
class InvitationDto with _$InvitationDto {
  const InvitationDto._();

  const factory InvitationDto({
    required String id,
    required String creatorId,
    required String title,
    required InvitationType type,
    @ServerDateStringConverter() required DateTime eventDate,
    @ServerDateStringConverter() required DateTime creationDate,
    @ServerDateStringConverter() required DateTime lastModificationDate,
  }) = _InvitationDto;

  factory InvitationDto.fromDomain(Invitation invitation) => InvitationDto(
        id: invitation.id.getOrCrash(),
        creatorId: invitation.creatorId.getOrCrash(),
        title: invitation.title.getOrCrash(),
        type: invitation.type,
        eventDate: invitation.eventDate.getOrCrash(),
        creationDate: invitation.creationDate.getOrCrash(),
        lastModificationDate: invitation.lastModificationDate.getOrCrash(),
      );

  Invitation toDomain() => Invitation(
        id: UniqueId.fromUniqueString(id),
        creatorId: UniqueId.fromUniqueString(creatorId),
        title: Title(title),
        type: type,
        eventDate: FutureDate(eventDate),
        creationDate: PastDate(creationDate),
        lastModificationDate: PastDate(lastModificationDate),
      );

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);
}
