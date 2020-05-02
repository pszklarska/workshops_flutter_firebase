import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'main.dart';

class FirebaseClient {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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

  void saveNewUser(User user) {
    Firestore.instance
        .collection('users')
        .document()
        .setData({'name': '${user.name}', 'token': '${user.token}'});
  }

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }
}
