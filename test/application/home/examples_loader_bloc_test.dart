import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/application/home/examples_loader/examples_loader_bloc.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/home/repository/home_repository_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'examples_loader_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HomeRepositoryInterface>()])
void main() {
  late MockHomeRepositoryInterface mockRepository;
  late ExamplesLoaderBloc exampleLoaderBloc;

  final failure = Failure.data(
    DataFailure.serverError(errorString: "error"),
  );

  final invitations = [getValidInvitation()];

  setUp(
    () {
      mockRepository = MockHomeRepositoryInterface();
      exampleLoaderBloc = ExamplesLoaderBloc(mockRepository);
    },
  );

  blocTest<ExamplesLoaderBloc, ExamplesLoaderState>(
    'emits [actionInProgress, loadSuccess] when LoadedExamples is added and repository returns Right',
    build: () {
      when(mockRepository.getExampleInvitations()).thenAnswer(
        (_) async => right(invitations),
      );
      return exampleLoaderBloc;
    },
    act: (bloc) => bloc.add(const ExamplesLoaderEvent.loadedExamples()),
    verify: (_) => mockRepository.getExampleInvitations(),
    expect: () => [
      const ExamplesLoaderState.actionInProgress(),
      ExamplesLoaderState.loadSuccess(invitations),
    ],
  );

  blocTest<ExamplesLoaderBloc, ExamplesLoaderState>(
    'emits [actionInProgress, loadFailure] when LoadedExamples is added and repository returns Left',
    build: () {
      when(mockRepository.getExampleInvitations()).thenAnswer(
        (_) async => left(failure),
      );
      return exampleLoaderBloc;
    },
    act: (bloc) => bloc.add(const ExamplesLoaderEvent.loadedExamples()),
    verify: (_) => mockRepository.getExampleInvitations(),
    expect: () => [
      const ExamplesLoaderState.actionInProgress(),
      ExamplesLoaderState.loadFailure(failure),
    ],
  );
}
