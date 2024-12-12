part of 'examples_loader_bloc.dart';

@freezed
class ExamplesLoaderEvent with _$ExamplesLoaderEvent {
  const factory ExamplesLoaderEvent.loadedExamples() = _LoadedExamples;
}
