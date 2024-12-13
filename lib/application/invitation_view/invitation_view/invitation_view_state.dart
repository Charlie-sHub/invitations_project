part of 'invitation_view_bloc.dart';

@freezed
class InvitationViewState with _$InvitationViewState {
  const factory InvitationViewState.initial() = _Initial;

  const factory InvitationViewState.actionInProgress() = _ActionInProgress;

  const factory InvitationViewState.loadSuccess(
    Invitation invitation,
  ) = _LoadSuccess;

  const factory InvitationViewState.loadFailure(
    Failure<dynamic> failure,
  ) = _loadFailure;
}
