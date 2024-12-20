import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/misc/invitation_type.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';
import 'package:invitations_project/domain/core/validation/objects/past_date.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:logger/logger.dart';

part 'invitation_editor_event.dart';

part 'invitation_editor_state.dart';

part 'invitation_editor_bloc.freezed.dart';

@injectable
class InvitationEditorBloc
    extends HydratedBloc<InvitationEditorEvent, InvitationEditorState> {
  final Logger _logger;

  InvitationEditorBloc(this._logger) : super(InvitationEditorState.initial()) {
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

  @override
  InvitationEditorState? fromJson(Map<String, dynamic> json) {
    try {
      final dto = InvitationDto.fromJson(
        json['invitation'] as Map<String, dynamic>,
      );
      return InvitationEditorState(
        invitation: dto.toDomain(),
        showErrorMessages: json['showErrorMessages'] as bool,
        hasSubmitted: json['hasSubmitted'] as bool,
        failureOrSuccessOption:
            none(), // We don't persist failures or successes
      );
    } catch (error) {
      _logger.e('Could not restore InvitationEditorState from JSON: $error');
      return InvitationEditorState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(InvitationEditorState state) => {
        'invitation': InvitationDto.fromDomain(state.invitation).toJson(),
        'showErrorMessages': state.showErrorMessages,
        'hasSubmitted': state.hasSubmitted,
      };
}
