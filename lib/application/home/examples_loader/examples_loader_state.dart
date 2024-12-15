part of 'examples_loader_bloc.dart';

@freezed
class ExamplesLoaderState with _$ExamplesLoaderState {
  const factory ExamplesLoaderState.actionInProgress() = _ActionInProgress;

  const factory ExamplesLoaderState.loadSuccess(
    List<Invitation> invitations,
  ) = _LoadSuccess;

  const factory ExamplesLoaderState.loadFailure(
    Failure<dynamic> failure,
  ) = _loadFailure;
}
