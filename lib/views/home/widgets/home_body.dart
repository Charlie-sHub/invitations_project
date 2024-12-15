import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/home/examples_loader/examples_loader_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/widgets/invitations_progress_indicator.dart';

import 'examples_grid.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExamplesLoaderBloc>()
        ..add(ExamplesLoaderEvent.loadedExamples()),
      child: BlocBuilder<ExamplesLoaderBloc, ExamplesLoaderState>(
        builder: (context, state) => state.when(
          actionInProgress: () => InvitationsProgressIndicator(),
          loadSuccess: (invitations) => ExamplesGrid(
            invitations: invitations,
          ),
          loadFailure: (failure) => Text(
            failure.toString(),
          ),
        ),
      ),
    );
  }
}
