import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/app_state.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/bloc_events.dart';
import 'dart:math' as math;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(
          const AppState.empty(),
        ) {
    on<LoadNextUrlEvent>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          data: null,
          error: null,
        ),
      );
      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }
        final bundle = NetworkAssetBundle(Uri.parse(url));
        final data = (await bundle.load(url)).buffer.asUint8List();
        emit(
          AppState(
            data: data,
            isLoading: false,
            error: null,
          ),
        );
      } catch (e) {
        AppState(
          isLoading: false,
          data: null,
          error: e,
        );
      }
    });
  }
}
