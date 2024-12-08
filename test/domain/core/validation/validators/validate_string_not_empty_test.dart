import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_not_empty.dart';

void main() {
  const validString = "Test";
  const invalidString = "";
  test(
    "Should return validString",
    () async {
      // Act
      final result = _act(validString);
      // Assert
      expect(result, validString);
    },
  );
  test(
    "Should return EmptyString",
    () async {
      // Arrange
      const valueFailure =
          ValueFailure<String>.emptyString(failedValue: invalidString);
      // Act
      final result = _act(invalidString);
      // Assert
      expect(result, valueFailure);
    },
  );
}

dynamic _act(String validString) {
  final either = validateStringNotEmpty(validString);
  final result = either.fold(
    (valueFailure) => valueFailure,
    id,
  );
  return result;
}
