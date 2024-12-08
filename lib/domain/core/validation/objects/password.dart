import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/objects/value_object.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_password.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_length.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_not_empty.dart';

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  // Just chose a number that seemed sensible in the moment, nothing especial
  static const maxLength = 40;

  factory Password(String input) => Password._(
        validateStringLength(
          input: input,
          length: maxLength,
        )
            .flatMap(validateStringNotEmpty)
            .flatMap(validateSingleLineString)
            .flatMap(validatePassword),
      );

  const Password._(this.value);

  @override
  List<Either> get props => [value];
}
