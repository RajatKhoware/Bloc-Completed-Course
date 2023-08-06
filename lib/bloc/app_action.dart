import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class LoadingNextUrlEvent implements AppEvent {
  const LoadingNextUrlEvent();
}
