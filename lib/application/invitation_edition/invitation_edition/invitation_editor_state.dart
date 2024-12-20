part of 'invitation_editor_bloc.dart';

@freezed
class InvitationEditorState with _$InvitationEditorState {
  const factory InvitationEditorState({
    required Invitation invitation,
    required bool showErrorMessages,
    required bool hasSubmitted,
    required Option<Either<ValueFailure, Unit>> failureOrSuccessOption,
  }) = _InvitationEditorState;

  factory InvitationEditorState.initial() => InvitationEditorState(
        invitation: Invitation.empty(),
        showErrorMessages: false,
        hasSubmitted: false,
        failureOrSuccessOption: none(),
      );
}
