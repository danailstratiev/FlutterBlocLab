import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/app_bloc.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/app_state.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/bloc_events.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/extensions/stream/start_with.dart';

class AppBlocWiew<T extends AppBloc> extends StatelessWidget {
  const AppBlocWiew({super.key});

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
      child: BlocBuilder<T, AppState>(builder: (context, appState) {
        if (appState.error != null) {
          // we have an error
          return const Text(
            'An error occured. Try again in a moment!',
          );
        } else if (appState.data != null) {
          // we have data
          return Image.memory(
            appState.data!,
            fit: BoxFit.fitHeight,
          );
        } else {
          // loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
