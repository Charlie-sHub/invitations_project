import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'invitation.freezed.dart';

@freezed
class Invitation with _$Invitation {
  const Invitation._();

  const factory Invitation({
    required UniqueId id,
    required UniqueId creatorId,
    required Title title,
    required InvitationType type,
    required FutureDate eventDate,
    required PastDate creationDate,
    required PastDate lastModificationDate,
    // TODO: Add the rest of the invitation's data
  }) = _Invitation;

  factory Invitation.empty() => Invitation(
    id: UniqueId(),
    creatorId: UniqueId(),
    title: Title(""),
    type: InvitationType.example,
    eventDate: FutureDate(DateTime.now().add(Duration(days: 7))),
    creationDate: PastDate(DateTime.now()),
    lastModificationDate: PastDate(DateTime.now()),
  );

  Option<ValueFailure<dynamic>> get failureOption {
    return title.failureOrUnit
        .andThen(eventDate.failureOrUnit)
        .andThen(creationDate.failureOrUnit)
        .andThen(lastModificationDate.failureOrUnit)
        .fold(
          (failure) => some(failure),
          (_) => none(),
        );
  }

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return failureOption.fold(
      () => right(unit),
      (failure) => left(failure),
    );
  }

  bool get isValid => failureOption.isNone();


}
