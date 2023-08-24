import 'package:bloc_by_wckd/bloc/app_action.dart';
import 'package:bloc_by_wckd/bloc/app_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String>);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension GetRandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  // Pick Random Url From Iterables
  String _pickRandomUrl(Iterable<String> allUrl) => allUrl.getRandomElement();
  // Load Url Using NetworkAssetBundle
  Future<Uint8List> _loadUrl(String url) {
    return NetworkAssetBundle(Uri.parse(url)).load(url).then(
          (byteValue) => byteValue.buffer.asUint8List(),
        );
  }

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      // loading
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
        // Load Data from network
        final data = await (urlLoader ?? _loadUrl)(url);
        // data
        emit(
          AppState(
            isLoading: false,
            data: data,
            error: null,
          ),
        );
      } catch (e) {
        // error
        emit(
          AppState(
            isLoading: false,
            data: null,
            error: e,
          ),
        );
      }
    });
  }
}
