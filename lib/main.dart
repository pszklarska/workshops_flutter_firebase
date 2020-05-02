import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final List<String> names = ['Mo', 'Jenny', 'Leo', 'Lukas', 'Jack', 'Serena'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, position) {
            return ListItem(names[position]);
          },
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String name;

  ListItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
