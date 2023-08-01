
import 'package:bloc_by_wckd/bloc/bloc_actions.dart';
import 'package:bloc_by_wckd/bloc/person.dart';
import 'package:bloc_by_wckd/bloc/persons_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

final mockedPerson1 = [
  const Person(
    name: "Rajat",
    age: 20,
  )
];

final mockedPerson2 = [
  const Person(
    name: "Rajat",
    age: 20,
  )
];

Future<Iterable<Person>> getMockedPerson1(String _) =>
    Future.value(mockedPerson1);
Future<Iterable<Person>> getMockedPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('Test Person Bloc', () {
    late PersonBloc bloc;

    // Setup is run before any test and every test
    // Setup is not for entire group only once its
    // once per test in the group
    setUp(() => bloc = PersonBloc());

    blocTest<PersonBloc, FetchResult?>(
      "Test intitial state",
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    // Fetch mock data (person1) and compare it with fetchResult
    blocTest<PersonBloc, FetchResult?>(
      "Mock retrieving persons from first iterable",
      build: () => bloc,
      act: (bloc) {
        // Sending Events
        bloc.add(
          // Cache == false
          const LoadPersonsAction(
            url: "dummy_url_1",
            personsLoader: getMockedPerson1,
          ),
        );
        // Cache == true
        bloc.add(
          const LoadPersonsAction(
            url: "dummy_url_1",
            personsLoader: getMockedPerson1,
          ),
        );
      },
      expect: () => [
        // Setting State acc to events
        FetchResult(
          person: mockedPerson1,
          isRetrivedFromCashed: false,
        ),
        FetchResult(
          person: mockedPerson1,
          isRetrivedFromCashed: true,
        ),
      ],
    );

    // Fetch mock data (person1) and compare it with fetchResult
    blocTest<PersonBloc, FetchResult?>(
      "Mock retrieving persons from second iterable",
      build: () => bloc,
      act: (bloc) {
        // Sending Events
        bloc.add(
          // Cache == false
          const LoadPersonsAction(
            url: "dummy_url_2",
            personsLoader: getMockedPerson2,
          ),
        );
        // Cache == true
        bloc.add(
          const LoadPersonsAction(
            url: "dummy_url_2",
            personsLoader: getMockedPerson2,
          ),
        );
      },
      expect: () => [
        // Setting State acc to events
        FetchResult(
          person: mockedPerson2,
          isRetrivedFromCashed: false,
        ),
        FetchResult(
          person: mockedPerson2,
          isRetrivedFromCashed: true,
        ),
      ],
    );
  });
}
