import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/home/repository/home_repository_interface.dart';

part 'examples_loader_event.dart';

part 'examples_loader_state.dart';

part 'examples_loader_bloc.freezed.dart';

@injectable
class ExamplesLoaderBloc
    extends Bloc<ExamplesLoaderEvent, ExamplesLoaderState> {

  ExamplesLoaderBloc(this._repository)
      : super(const ExamplesLoaderState.actionInProgress()) {
    on<ExamplesLoaderEvent>(
      (event, emit) => event.when(
        loadedExamples: () async {
          emit(const ExamplesLoaderState.actionInProgress());
          final failureOrUnit = await _repository.getExampleInvitations();
          emit(
            failureOrUnit.fold(
              ExamplesLoaderState.loadFailure,
              ExamplesLoaderState.loadSuccess,
            ),
          );
          return null;
        },
      ),
    );
  }
  final HomeRepositoryInterface _repository;
}
