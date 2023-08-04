import 'package:flutter/material.dart';

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableToListview(iterable: this);
}

class IterableToListview<T> extends StatelessWidget {
  final Iterable iterable;
  const IterableToListview({super.key, required this.iterable});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iterable.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            iterable.elementAt(index).toString(),
          ),
        );
      },
    );
  }
}
