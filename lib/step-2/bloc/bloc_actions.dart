import 'package:bloc_by_wckd/step-2/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const persons1Url = 'http://192.168.1.2:5500/api/person1.js';
const persons2Url = 'http://192.168.1.2:5500/api/person2.js';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable // Event Parent Class
abstract class LoadAction {
  const LoadAction();
}

@immutable // Event Subclass Class
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader personsLoader;
  const LoadPersonsAction({
    required this.url,
    required this.personsLoader,
  }) : super();
}
