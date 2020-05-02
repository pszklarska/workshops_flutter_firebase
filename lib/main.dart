import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workshops_flutter_firebase/firebase_client.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final FirebaseClient firebaseClient = FirebaseClient();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
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
                  return ListItem(
                    user: snapshot.data[position],
                    onUserTap: firebaseClient.sendMessage,
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _addNewUser(context),
          ),
        ),
      ),
    );
  }

  void _addNewUser(BuildContext context) async {
    final String username = await showDialog(
      context: context,
      builder: (context) => EnterNameDialog(),
    );

    if (username != null) {
      final String token = await firebaseClient.getToken();
      final User user = User(username, token);
      firebaseClient.saveNewUser(user);
    }
  }
}

class ListItem extends StatelessWidget {
  final User user;
  final Function(String token) onUserTap;

  ListItem({
    this.user,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onUserTap(user.token),
      child: Container(
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
      ),
    );
  }
}

class EnterNameDialog extends StatefulWidget {
  EnterNameDialog({Key key}) : super(key: key);

  @override
  _EnterNameDialogState createState() => _EnterNameDialogState();
}

class _EnterNameDialogState extends State<EnterNameDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter your name'),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(hintText: "Name"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () =>
              Navigator.of(context).pop(_textController.text.toString()),
        )
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class User {
  final String name;
  final String token;

  User(this.name, this.token);
}
