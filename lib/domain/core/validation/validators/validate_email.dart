import 'package:dartz/dartz.dart';
import 'package:email_validator/email_validator.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

Either<ValueFailure<String>, String> validateEmail(String input) {
  if (EmailValidator.validate(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}
