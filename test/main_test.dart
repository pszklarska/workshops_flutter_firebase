import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:workshops_flutter_firebase/firebase_client.dart';
import 'package:workshops_flutter_firebase/main.dart';

void main() {
  final FirebaseClientMock firebaseClient = FirebaseClientMock();

  testWidgets('usernames are visible when repository returns success', (WidgetTester tester) async {
    StreamController controller = StreamController<List<User>>();
    controller.add([
      User('Joe', ''),
      User('Katy', ''),
      User('Mike', ''),
    ]);
    when(firebaseClient.getUsers()).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(App(firebaseClient: firebaseClient));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('JOE'), findsOneWidget);
    expect(find.text('KATY'), findsOneWidget);
    expect(find.text('MIKE'), findsOneWidget);

    await controller.close();
  });

  testWidgets('loader is visible when repository returns nothing', (WidgetTester tester) async {
    StreamController controller = StreamController<List<User>>();
    when(firebaseClient.getUsers()).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(App(firebaseClient: firebaseClient));
    await tester.pump();

    expect(find.text('Loading...'), findsOneWidget);

    await controller.close();
  });

  testWidgets('error text is visible when repository returns error', (WidgetTester tester) async {
    StreamController controller = StreamController<List<User>>();
    controller.addError(Exception());
    when(firebaseClient.getUsers()).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(App(firebaseClient: firebaseClient));
    await tester.pump();

    expect(find.text('Error: Exception'), findsOneWidget);

    await controller.close();
  });

  testWidgets('enter name dialog is open when button is clicked', (WidgetTester tester) async {
    StreamController controller = StreamController<List<User>>();
    when(firebaseClient.getUsers()).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(App(firebaseClient: firebaseClient));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byType(EnterNameDialog), findsOneWidget);

    await controller.close();
  });
}

class FirebaseClientMock extends Mock implements FirebaseClient {}
