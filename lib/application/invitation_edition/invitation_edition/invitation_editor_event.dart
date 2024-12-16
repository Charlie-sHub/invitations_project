part of 'invitation_editor_bloc.dart';

@freezed
class InvitationEditorEvent with _$InvitationEditorEvent {
  const factory InvitationEditorEvent.initialized(
    Invitation initialInvitation,
  ) = _Initialized;

  const factory InvitationEditorEvent.changedTitle(
    String title,
  ) = _ChangedTitle;

  const factory InvitationEditorEvent.changedDescription(
    String description,
  ) = _ChangedDescription;

  const factory InvitationEditorEvent.changedDate(
    DateTime date,
  ) = _ChangedDate;

  const factory InvitationEditorEvent.submitted() = _Submitted;
}
