import 'package:invitations_project/application/invitation_edition/invitation_edition/invitation_editor_bloc.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/invitation_edition/repository/invitation_edition_repository_interface.dart';
import 'package:mockito/annotations.dart';
import 'invitation_edition_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InvitationEditionRepositoryInterface>()])
void main() {
  late MockInvitationEditionRepositoryInterface mockRepository;
  late InvitationEditorBloc purchaseBloc;

  final invitation = getValidInvitation();

  // TODO: Test the InvitationEditorBloc
}
