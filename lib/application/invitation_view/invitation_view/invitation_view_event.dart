part of 'invitation_view_bloc.dart';

@freezed
class InvitationViewEvent with _$InvitationViewEvent {
  const factory InvitationViewEvent.loadedInvitation(String id) = _LoadedInvitation;
}
