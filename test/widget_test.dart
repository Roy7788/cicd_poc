import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicd_poc/main.dart';

void main() {
  testWidgets('Login fails with empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Username and password required'), findsOneWidget);
  });

  testWidgets('Login fails with wrong credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const Key('usernameField')), 'Sandeep');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpass');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('Login succeeds and navigates to Home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const Key('usernameField')), 'Sandeep');
    await tester.enterText(find.byKey(const Key('passwordField')), 'test123');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Sandeep!'), findsOneWidget);
    expect(find.byKey(const Key('logoutButton')), findsOneWidget);
  });
}
