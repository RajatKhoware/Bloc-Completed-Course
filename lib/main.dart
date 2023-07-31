// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'package:bloc_by_wckd/bloc/bloc_actions.dart';
import 'package:bloc_by_wckd/bloc/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as devtools show log;

import 'bloc/persons_bloc.dart';

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

// Calling api Using HttpClient insted of http package
Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url)) // making get request to sever
    .then((req) => req.close()) // closing the request
    .then((response) =>
        response.transform(utf8.decoder).join()) // transfroming the response
    .then((str) => json.decode(str) as List<dynamic>) // json decoding
    .then((list) => list.map((e) => Person.fromJson(e))); // mapping

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
                  bloc.add(
                    const LoadPersonsAction(
                      url: persons1Url,
                      personsLoader: getPersons,
                    ),
                  );
                },
                child: const Text("# Get Person 1"),
              ),
              TextButton(
                onPressed: () {
                  final bloc = context.read<PersonBloc>();
                  // Adding a event load person Action to our bloc
                  bloc.add(
                    const LoadPersonsAction(
                      url: persons2Url,
                      personsLoader: getPersons,
                    ),
                  );
                },
                child: const Text("# Get Person 2"),
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
