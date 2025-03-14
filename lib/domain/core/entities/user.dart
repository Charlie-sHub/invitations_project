import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required UniqueId id,
    required EmailAddress email,
    required Set<UniqueId> invitationsIds,
    required PastDate lastLogin,
    required PastDate creationDate,
  }) = _User;

  factory User.empty() => User(
        id: UniqueId(),
        email: EmailAddress(""),
        invitationsIds: {},
        lastLogin: PastDate(DateTime.now()),
        creationDate: PastDate(DateTime.now()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    // Why is the id not checked?
    return email.failureOrUnit
        .andThen(lastLogin.failureOrUnit)
        .andThen(creationDate.failureOrUnit)
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
