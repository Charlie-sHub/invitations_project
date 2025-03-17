import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_email.dart';

void main() {
  const invalidEmail = 'test';
  const validEmail = 'test@test.com';
  test(
    'Should return back the valid email',
    () async {
      // Act
      final result = _act(validEmail);
      // Assert
      expect(result, validEmail);
    },
  );
  test(
    'Should return InvalidEmail',
    () async {
      // Act
      final result = _act(invalidEmail);
      // Assert
      expect(
        result,
        const ValueFailure<String>.invalidEmail(failedValue: invalidEmail),
      );
    },
  );
}

Object _act(String invalidEmail) {
  final either = validateEmail(invalidEmail);
  final result = either.fold(
    (valueFailure) => valueFailure,
    (validInput) => validInput,
  );
  return result;
}
