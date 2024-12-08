import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/converters/date_only_datetime.dart';
import 'package:invitations_project/domain/core/validation/objects/value_object.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_past_date.dart';

class PastDate extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  factory PastDate(DateTime input) => PastDate._(
        validatePastDate(input).flatMap(dateOnlyDateTime),
      );

  const PastDate._(this.value);

  @override
  List<Either> get props => [value];
}
