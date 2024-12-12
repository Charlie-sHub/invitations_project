part of 'invitation_editor_bloc.dart';

@freezed
class InvitationEditorState with _$InvitationEditorState {
  const factory InvitationEditorState({
    required Invitation invitation,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _InvitationEditorState;

  factory InvitationEditorState.initial(Invitation invitation) =>
      InvitationEditorState(
        invitation: invitation,
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
