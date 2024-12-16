import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:invitations_project/domain/invitation_edition/repository/invitation_edition_repository_interface.dart';

part 'invitation_editor_event.dart';

part 'invitation_editor_state.dart';

part 'invitation_editor_bloc.freezed.dart';

@injectable
class InvitationEditorBloc
    extends Bloc<InvitationEditorEvent, InvitationEditorState> {
  final InvitationEditionRepositoryInterface _repository;

  InvitationEditorBloc(this._repository)
      : super(InvitationEditorState.initial()) {
    on<InvitationEditorEvent>(
      (event, emit) => event.when(
        initialized: (initialInvitation) => emit(
          state.copyWith(invitation: initialInvitation),
        ),
        changedTitle: (title) => emit(
          state.copyWith(
            invitation: state.invitation.copyWith(
              title: Title(title),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        // Will the Invitations even have descriptions?
        changedDescription: (description) => null,
        changedDate: (date) => emit(
          state.copyWith(
            invitation: state.invitation.copyWith(
              eventDate: FutureDate(date),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        submitted: () {
          final invitationToSave = state.invitation.copyWith(
            type: InvitationType.normal,
            id: UniqueId(),
            creationDate: PastDate(DateTime.now()),
            lastModificationDate: PastDate(DateTime.now()),
            // The creator's id should maybe be added here
          );
          Either<Failure, Unit>? failureOrUnit;
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );
          if (invitationToSave.isValid) {
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
