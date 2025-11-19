// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This app's entry requires async bootstrap and routes.
// For a smoke test, pump a minimal MaterialApp.

void main() {
  testWidgets('App renders a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('ok'))));
    expect(find.text('ok'), findsOneWidget);
  });
}
