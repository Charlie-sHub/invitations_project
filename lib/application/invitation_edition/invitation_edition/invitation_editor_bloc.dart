import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/invitation_edition/repository/invitation_edition_repository_interface.dart';

part 'invitation_editor_event.dart';

part 'invitation_editor_state.dart';

part 'invitation_editor_bloc.freezed.dart';

class InvitationEditorBloc
    extends Bloc<InvitationEditorEvent, InvitationEditorState> {
  final InvitationEditionRepositoryInterface _repository;
  final Invitation _startingInvitation;

  InvitationEditorBloc(
    this._repository,
    this._startingInvitation,
  ) : super(InvitationEditorState.initial(_startingInvitation)) {
    on<InvitationEditorEvent>(
      (event, emit) => event.map(
        changedTitle: (event) {
          emit(
            state.copyWith(
              invitation: state.invitation.copyWith(
                title: Title(event.title),
              ),
              failureOrSuccessOption: none(),
            ),
          );
          return null;
        },
        changedDescription: (event) {
          // Will the Invitations even have descriptions?
          return null;
        },
        changedDate: (event) {
          emit(
            state.copyWith(
              invitation: state.invitation.copyWith(
                eventDate: FutureDate(event.date),
              ),
              failureOrSuccessOption: none(),
            ),
          );
          return null;
        },
        submitted: (_) {
          Either<Failure, Unit>? failureOrUnit;
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );
          if (state.invitation.isValid) {
            // TODO: Handle the submission of the invitation
          }
          emit(
            state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              failureOrSuccessOption: optionOf(failureOrUnit),
            ),
          );
          return null;
        },
      ),
    );
  }
}
