import 'app_bloc.dart';

class ButtomBLoc extends AppBloc {
  ButtomBLoc({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
