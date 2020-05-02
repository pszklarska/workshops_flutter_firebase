import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class FirebaseClient {
  Stream<List<User>> getUsers() {
    return Firestore.instance
        .collection('users')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.documents.map((document) {
        return User(document['name'], document['token']);
      }).toList();
    });
  }
}
