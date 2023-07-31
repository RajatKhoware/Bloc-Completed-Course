// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    );
  }
}

enum PersonUrl { person1, person2 }

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://192.168.1.2:5500/api/person1.js';
      case PersonUrl.person2:
        return 'http://192.168.1.2:5500/api/person2.js';
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => ("Person name : $name, age : $age");
}

// Calling api Using HttpClient insted of http package
Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url)) // making get request to sever
    .then((req) => req.close()) // closing the request
    .then((response) =>
        response.transform(utf8.decoder).join()) // transfroming the response
    .then((str) => json.decode(str) as List<dynamic>) // json decoding
    .then((list) => list.map((e) => Person.fromJson(e))); // mapping

@immutable // Event Parent Class
abstract class LoadAction {
  const LoadAction();
}

@immutable // Event Subclass Class
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({required this.url}) : super();
}

abstract class LoadingEvent {
  const LoadingEvent();
}

class SetLoadingEvent extends LoadingEvent {
  final bool isLoading;
  const SetLoadingEvent({required this.isLoading}) : super();
}

class LoadingState extends LoadingEvent {
  final bool isLoading;
  LoadingState({required this.isLoading});
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
}

// Step 2: Create the event and state classes for the BLoC

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cached = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cached.containsKey(url)) {
        // We Have the value in cached
        final cachedPerson = _cached[url]!;
        final result = FetchResult(
          person: cachedPerson,
          isRetrivedFromCashed: true,
        );
        emit(result);
      } else {
        // We dont have any data cached
        final person = await getPersons(url.urlString);
        // storing person into cache form that url
        _cached[url] = person;
        final result = FetchResult(
          person: person,
          isRetrivedFromCashed: false,
        );
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  final bloc = context.read<PersonBloc>();
                  // Adding a event load person Action to our bloc
                  bloc.add(const LoadPersonsAction(url: PersonUrl.person1));
                },
                child: const Text("#Get Person 1"),
              ),
              TextButton(
                onPressed: () {
                  final bloc = context.read<PersonBloc>();
                  // Adding a event load person Action to our bloc
                  bloc.add(const LoadPersonsAction(url: PersonUrl.person2));
                },
                child: const Text("#Get Person 1"),
              ),
            ],
          ),
          BlocBuilder<PersonBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.person != currentResult?.person;
            },
            builder: (context, state) {
              state?.log();
              final persons = state?.person;
              if (persons == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index];
                    return ListTile(
                      title: Text(person!.name),
                      subtitle: Text(person.age.toString()),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
