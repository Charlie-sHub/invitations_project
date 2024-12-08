import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_failure.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidDate({required DateTime failedValue}) =
      InvalidDate<T>;

  const factory ValueFailure.invalidEmail({required String failedValue}) =
      InvalidEmail<T>;

  const factory ValueFailure.invalidPassword({required String failedValue}) =
      InvalidPassword<T>;

  const factory ValueFailure.invalidTitle({required String failedValue}) =
      invalidTitle<T>;

  const factory ValueFailure.emptyString({required String failedValue}) =
      EmptyString<T>;

  const factory ValueFailure.multiLineString({required String failedValue}) =
      MultiLineString<T>;

  const factory ValueFailure.stringExceedsLength({
    required String failedValue,
    required int maxLength,
  }) = StringExceedsLength<T>;
}
