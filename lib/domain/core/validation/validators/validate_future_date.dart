import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

Either<ValueFailure<DateTime>, DateTime> validateFutureDate(DateTime input) {
  if (!DateTime.now().isAfter(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDate(failedValue: input));
  }
}
