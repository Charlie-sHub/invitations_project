import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';

part 'failure.freezed.dart';

@freezed
class Failure<T> with _$Failure<T> {
  const factory Failure.data(DataFailure<T> dataFailure) = _Data<T>;

  const factory Failure.value(ValueFailure<T> valueFailure) = _Value<T>;
}
