import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicd_poc/home_screen.dart';

void main() {
  group('HomeScreen widget tests', () {
    testWidgets('shows welcome message with the given username',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(username: 'rahul')),
      );

      expect(find.text('Welcome, rahul!'), findsOneWidget);
      expect(find.text('You have successfully logged in'), findsOneWidget);
    });

    testWidgets('shows Session Info section with username and status',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(username: 'rahul')),
      );

      expect(find.text('Session Info'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('rahul'), findsWidgets);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows App Info section with app details', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(username: 'rahul')),
      );

      expect(find.text('App Info'), findsOneWidget);
      expect(find.text('App Name'), findsOneWidget);
      expect(find.text('CI/CD POC App'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('Framework'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('shows the POC demonstrates section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(username: 'rahul')),
      );

      expect(find.text('This POC Demonstrates'), findsOneWidget);
      expect(find.text('Unit Testing'), findsOneWidget);
      expect(find.text('Widget Testing'), findsOneWidget);
      expect(find.text('API Testing'), findsOneWidget);
      expect(find.text('Quality Gate'), findsOneWidget);
      expect(find.text('CI/CD'), findsOneWidget);
    });

    testWidgets('has a logout button that pops the screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(username: 'rahul'),
                    ),
                  );
                },
                child: const Text('Go to Home'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Home'));
      await tester.pumpAndSettle();

      final logoutFinder = find.byKey(const Key('logoutButton'));
      await tester.ensureVisible(logoutFinder);
      await tester.pumpAndSettle();

      expect(logoutFinder, findsOneWidget);

      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();

      expect(find.text('Go to Home'), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('shows a different username when a different one is passed',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(username: 'priya')),
      );

      expect(find.text('Welcome, priya!'), findsOneWidget);
    });
  });
}
