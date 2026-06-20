import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:baafata_faaruu/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BaafataFaaruuApp());

    // Verify that the app title is displayed
    expect(find.text('Baafata Faaruu'), findsOneWidget);
  });
}
