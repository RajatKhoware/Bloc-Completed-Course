// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart' show immutable;
import 'package:bloc_by_wckd/model.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandler? loginHandler;
  final Iterable<Notes>? notes;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandler,
    required this.notes,
  });

  // Initial State
  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandler = null,
        notes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginErrors': loginErrors,
        'loginHandler': loginHandler,
        'notes': notes,
      }.toString();

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesAreEquall = isLoading == other.isLoading &&
        loginErrors == other.loginErrors &&
        loginHandler == other.loginHandler;
    if (notes == null && other.notes == null) {
      return otherPropertiesAreEquall;
    } else {
      return otherPropertiesAreEquall &&
          (notes?.isEqualTo(other.notes) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginErrors,
        loginHandler,
        notes,
      );
}

extension UnOrderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
        this,
        other,
      );
}
