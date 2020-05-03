import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:workshops_flutter_firebase/firebase_helper.dart';
import 'package:workshops_flutter_firebase/player.dart';

import 'main.dart';

class FirebaseClient {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Player player = Player();

  void init() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        player.playSound();
      },
    );
  }

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

  void sendMessage(String token) async {
    final Response response = await post(
      FirebaseHelper.fcmUrl,
      body: jsonEncode(FirebaseHelper.getMessageBody(token)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=${FirebaseHelper.serverKey}',
      },
    );

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error fetching data!");
    }
  }
}
