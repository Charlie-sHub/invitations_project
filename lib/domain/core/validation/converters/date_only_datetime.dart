import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

// ValueFailure is only there to appease the compiler
Either<ValueFailure<DateTime>, DateTime> dateOnlyDateTime(DateTime dateTime) {
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  return right(date);
}
