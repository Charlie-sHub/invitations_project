import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:invitations_project/domain/invitation_view/repository/invitation_view_repository_interface.dart';

part 'invitation_view_event.dart';

part 'invitation_view_state.dart';

part 'invitation_view_bloc.freezed.dart';

@injectable
class InvitationViewBloc
    extends Bloc<InvitationViewEvent, InvitationViewState> {

  InvitationViewBloc(this._repository)
      : super(const InvitationViewState.initial()) {
    on<InvitationViewEvent>(
      (event, emit) => event.when(
        loadedInvitation: (id) async {
          emit(const InvitationViewState.actionInProgress());
          final uniqueId = UniqueId.fromUniqueString(id);
          uniqueId.value.fold(
            (failure) => emit(
              InvitationViewState.loadFailure(
                Failure.value(failure),
              ),
            ),
            (_) => _repository.loadInvitation(uniqueId).then(
                  (failureOrUnit) => emit(
                    failureOrUnit.fold(
                      InvitationViewState.loadFailure,
                      InvitationViewState.loadSuccess,
                    ),
                  ),
                ),
          );
/*
          if (uniqueId.isValid()) {
            final failureOrUnit = await _repository.loadInvitation(uniqueId);
            emit(
              failureOrUnit.fold(
                (failure) => InvitationViewState.loadFailure(failure),
                (invitation) => InvitationViewState.loadSuccess(invitation),
              ),
            );
          } else {
            emit(
              InvitationViewState.loadFailure(
                Failure.value(uniqueId.failureOrCrash()),
              ),
            );
          }

 */
          return null;
        },
      ),
    );
  }
  final InvitationViewRepositoryInterface _repository;
}
