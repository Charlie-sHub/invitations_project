import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/application/invitation_view/invitation_view/invitation_view_bloc.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/invitation_view/repository/invitation_view_repository_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'invitation_view_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InvitationViewRepositoryInterface>()])
void main() {
  late MockInvitationViewRepositoryInterface mockRepository;
  late InvitationViewBloc invitationViewBloc;

  final invitation = getValidInvitation();
  final id = invitation.id.getOrCrash();
  const emptyId = '';
  const failure = Failure.data(
    DataFailure.serverError(errorString: 'error'),
  );

  setUp(
    () {
      mockRepository = MockInvitationViewRepositoryInterface();
      invitationViewBloc = InvitationViewBloc(mockRepository);
    },
  );

  blocTest<InvitationViewBloc, InvitationViewState>(
    'emits [actionInProgress, loadSuccess] when LoadedInvitation '
    'is added and repository returns Right',
    build: () {
      when(mockRepository.loadInvitation(any)).thenAnswer(
        (_) async => right(invitation),
      );
      return invitationViewBloc;
    },
    act: (bloc) => bloc.add(InvitationViewEvent.loadedInvitation(id)),
    verify: (_) => mockRepository.loadInvitation(invitation.id),
    expect: () => [
      const InvitationViewState.actionInProgress(),
      InvitationViewState.loadSuccess(invitation),
    ],
  );

  blocTest<InvitationViewBloc, InvitationViewState>(
    'emits [actionInProgress, loadFailure] when LoadedInvitation '
    'is added and repository returns Left',
    build: () {
      when(mockRepository.loadInvitation(any)).thenAnswer(
        (_) async => left(failure),
      );
      return invitationViewBloc;
    },
    act: (bloc) => bloc.add(InvitationViewEvent.loadedInvitation(id)),
    verify: (_) => mockRepository.loadInvitation(invitation.id),
    expect: () => [
      const InvitationViewState.actionInProgress(),
      const InvitationViewState.loadFailure(failure),
    ],
  );

  blocTest<InvitationViewBloc, InvitationViewState>(
    'emits [actionInProgress, loadFailure] when LoadedInvitation '
    'is added and the id is a value failure',
    build: () => invitationViewBloc,
    act: (bloc) =>
        bloc.add(const InvitationViewEvent.loadedInvitation(emptyId)),
    expect: () => [
      const InvitationViewState.actionInProgress(),
      const InvitationViewState.loadFailure(
        Failure.value(
          ValueFailure<String>.emptyString(failedValue: emptyId),
        ),
      ),
    ],
  );
}
