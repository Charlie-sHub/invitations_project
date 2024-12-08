import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required UniqueId id,
    required EmailAddress email,
    required Password password,
    required List<Invitation> invitations,
    required PastDate lastLogin,
    required PastDate creationDate,
  }) = _User;

  Option<ValueFailure<dynamic>> get failureOption {
    // Why is the id not checked?
    return email.failureOrUnit
        .andThen(password.failureOrUnit)
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
