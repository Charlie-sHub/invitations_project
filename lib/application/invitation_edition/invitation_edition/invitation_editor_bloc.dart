import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

part 'invitation_editor_event.dart';

part 'invitation_editor_state.dart';

part 'invitation_editor_bloc.freezed.dart';

@injectable
class InvitationEditorBloc
    extends Bloc<InvitationEditorEvent, InvitationEditorState> {
  InvitationEditorBloc() : super(InvitationEditorState.initial()) {
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
          ),
        ),
        // Will the Invitations even have descriptions?
        changedDescription: (description) => null,
        changedDate: (date) => emit(
          state.copyWith(
            invitation: state.invitation.copyWith(
              eventDate: FutureDate(date),
            ),
          ),
        ),
        submitted: () => state.invitation.failureOption.fold(
          () => emit(
            state.copyWith(
              invitation: state.invitation.copyWith(
                type: InvitationType.normal,
                id: UniqueId(),
                lastModificationDate: PastDate(DateTime.now()),
                // The creator's id should maybe be added here
              ),
              hasSubmitted: true,
            ),
          ),
          (failure) => emit(
            state.copyWith(
              hasSubmitted: false,
              showErrorMessages: true,
              failureOrSuccessOption: some(left(failure)),
            ),
          ),
        ),
      ),
    );
  }
}
