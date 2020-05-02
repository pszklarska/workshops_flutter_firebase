import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workshops_flutter_firebase/firebase_client.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final FirebaseClient firebaseClient = FirebaseClient();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: StreamBuilder<List<User>>(
          stream: firebaseClient.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return ListItem(snapshot.data[position]);
              },
            );
          },
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final User user;

  ListItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          user.name.toUpperCase(),
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

class User {
  final String name;
  final String token;

  User(this.name, this.token);
}
