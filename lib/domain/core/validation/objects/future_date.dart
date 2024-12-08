import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/converters/date_only_datetime.dart';
import 'package:invitations_project/domain/core/validation/objects/value_object.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_future_date.dart';

class FutureDate extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  factory FutureDate(DateTime input) => FutureDate._(
        validateFutureDate(input).flatMap(dateOnlyDateTime),
      );

  const FutureDate._(this.value);

  @override
  List<Either> get props => [value];
}
