import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/objects/value_object.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_email.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) => EmailAddress._(validateEmail(input));

  const EmailAddress._(this.value);

  @override
  List<Either> get props => [value];
}
