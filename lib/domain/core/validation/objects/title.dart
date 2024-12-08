import 'package:dartz/dartz.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/objects/value_object.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_length.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_string_not_empty.dart';

class Title extends ValueObject<String> {
  static const maxLength = 50;

  @override
  final Either<ValueFailure<String>, String> value;

  factory Title(String input) => Title._(
        validateStringLength(
          input: input,
          length: maxLength,
        ).flatMap(validateStringNotEmpty).flatMap(validateSingleLineString),
      );

  const Title._(this.value);

  @override
  List<Either> get props => [value];
}
