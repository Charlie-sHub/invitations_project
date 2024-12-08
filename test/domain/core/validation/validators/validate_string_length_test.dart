import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_length.dart';

void main() {
  const validString = "TestTest";
  const invalidString = "TestTestTest";
  const length = 10;
  test(
    "Should return validString",
    () async {
      // Act
      final Object result = _act(validString, length);
      // Assert
      expect(result, validString);
    },
  );
  test(
    "Should return StringExceedsLength",
    () async {
      // Arrange
      const valueFailure = ValueFailure<String>.stringExceedsLength(
        failedValue: invalidString,
        maxLength: length,
      );
      // Act
      final Object result = _act(invalidString, length);
      // Assert
      expect(result, valueFailure);
    },
  );
}

Object _act(String input, int length) {
  final either = validateStringLength(
    input: input,
    length: length,
  );
  final result = either.fold(
    (valueFailure) => valueFailure,
    (validInput) => validInput,
  );
  return result;
}
