import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_past_date.dart';

void main() {
  final validDate = DateTime.now();
  final invalidDate = DateTime.now().add(const Duration(days: 50));
  test(
    "Should return validDate",
    () async {
      // Act
      final Object result = _act(validDate);
      // Assert
      expect(result, validDate);
    },
  );
  test(
    "Should return InvalidDate",
    () async {
      // Act
      final Object result = _act(invalidDate);
      // Assert
      expect(
        result,
        ValueFailure<DateTime>.invalidDate(failedValue: invalidDate),
      );
    },
  );
}

Object _act(DateTime input) {
  final either = validatePastDate(input);
  final result = either.fold(
    (valueFailure) => valueFailure,
    (validInput) => validInput,
  );
  return result;
}
