import 'package:bloc_by_wckd/bloc/app_action.dart';
import 'package:bloc_by_wckd/bloc/app_bloc.dart';
import 'package:bloc_by_wckd/bloc/app_state.dart';
import 'package:bloc_by_wckd/extensions/stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach(
      (event) {
        context.read<T>().add(event);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (appState.data != null) {
            return Image.memory(
              appState.data!,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            );
          } else {
            return const Text('An error occurred. Try again in a moment!');
          }
        },
      ),
    );
  }
}
