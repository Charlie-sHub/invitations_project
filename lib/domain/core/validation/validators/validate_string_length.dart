import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

Either<ValueFailure<String>, String> validateStringLength({
  required String input,
  required int length,
}) {
  if (input.length <= length) {
    return right(input);
  } else {
    return left(
      ValueFailure.stringExceedsLength(
        failedValue: input,
        maxLength: length,
      ),
    );
  }
}
