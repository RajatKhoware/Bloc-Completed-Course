import 'package:bloc/bloc.dart';
import 'package:bloc_by_wckd/step-2/bloc/bloc_actions.dart';

import 'person.dart';

// If we are working with list we dont have to do that but form now
// we are working with iterables and itreables do not guarantee [index]
extension IsEquallToIgnoringOrdering<T> on Iterable<T> {
  bool isEquallToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      // ... is set and we are checking if the this sets have similer
      // intersection or not
      {...this}.intersection({...other}).length == length;
}

class FetchResult {
  final Iterable<Person> person;
  final bool isRetrivedFromCashed;

  FetchResult({
    required this.person,
    required this.isRetrivedFromCashed,
  });

  @override
  String toString() =>
      "FetchedResult (isRetrivedFromCached = $isRetrivedFromCashed, person = $person)";

  @override // Checking for equality for testing
  bool operator ==(covariant FetchResult other) =>
      person.isEquallToIgnoringOrdering(other.person) &&
      isRetrivedFromCashed == other.isRetrivedFromCashed;

  @override
  int get hashCode => Object.hash(person, isRetrivedFromCashed);
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        // We Have the value in cached
        final cachedPerson = _cache[url]!;
        final result = FetchResult(
          person: cachedPerson,
          isRetrivedFromCashed: true,
        );
        emit(result);
      } else {
        final loader = event.personsLoader;
        final persons = await loader(url);
        // storing person into cache form that url
        _cache[url] = persons;
        final result = FetchResult(
          person: persons,
          isRetrivedFromCashed: false,
        );
        emit(result);
      }
    });
  }
}
