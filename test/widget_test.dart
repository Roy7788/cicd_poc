import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicd_poc/main.dart';

// Functional tests: har test app ke ek "behavior" ko check karta hai
// bina internal code implementation ki fikar kiye — sirf output/UI check hota hai

void main() {
  testWidgets('Login fails with empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Directly login button daba do, kuch bhi bhare bina
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Username and password required'), findsOneWidget);
  });

  testWidgets('Login fails with wrong credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const Key('usernameField')), 'rahul');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpass');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('Login succeeds with correct credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const Key('usernameField')), 'rahul');
    await tester.enterText(find.byKey(const Key('passwordField')), 'test123');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Login successful'), findsOneWidget);
  });
}
