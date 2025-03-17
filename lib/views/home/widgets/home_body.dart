import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/home/examples_loader/examples_loader_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/widgets/invitations_progress_indicator.dart';

import 'package:invitations_project/views/home/widgets/examples_grid.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => getIt<ExamplesLoaderBloc>()
        ..add(const ExamplesLoaderEvent.loadedExamples()),
      child: BlocBuilder<ExamplesLoaderBloc, ExamplesLoaderState>(
        builder: (context, state) => state.when(
          actionInProgress: InvitationsProgressIndicator.new,
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
