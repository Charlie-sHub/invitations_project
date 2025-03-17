import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_future_date.dart';

void main() {
  final validDate = DateTime.now().add(const Duration(days: 50));
  final invalidDate = DateTime.now();
  test(
    'Should return validDate',
    () async {
      // Act
      final result = _act(validDate);
      // Assert
      expect(result, validDate);
    },
  );
  test(
    'Should return InvalidDate',
    () async {
      // Act
      final result = _act(invalidDate);
      // Assert
      expect(
        result,
        ValueFailure<DateTime>.invalidDate(failedValue: invalidDate),
      );
    },
  );
}

Object _act(DateTime input) {
  final either = validateFutureDate(input);
  final result = either.fold(
    (valueFailure) => valueFailure,
    (validInput) => validInput,
  );
  return result;
}
