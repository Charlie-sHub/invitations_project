import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

Either<ValueFailure<DateTime>, DateTime> validatePastDate(DateTime input) {
  final now = DateTime.now();
  if (input.isBefore(now) || input.isAtSameMomentAs(now)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDate(failedValue: input));
  }
}
