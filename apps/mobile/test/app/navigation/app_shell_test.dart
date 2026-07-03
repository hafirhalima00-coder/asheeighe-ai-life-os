import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pinkz/app/navigation/app_shell.dart';
import 'package:pinkz/app/navigation/bottom_nav.dart';

class FakeGoRouter extends Fake implements GoRouter {
  @override
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    // no-op for testing
  }
}

class _TestPage extends StatelessWidget {
  final String label;
  const _TestPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}

void main() {
  group('AppShell', () {
    testWidgets('should render child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(
            child: const _TestPage(label: 'Dashboard Content'),
          ),
        ),
      );

      expect(find.text('Dashboard Content'), findsOneWidget);
    });

    testWidgets('should render bottom navigation bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(PinkzNavigationBar), findsOneWidget);
    });

    testWidgets('should contain Scaffold with drawer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render all bottom nav destinations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('AI Chat'), findsWidgets);
      expect(find.text('Calendar'), findsWidgets);
      expect(find.text('Tasks'), findsWidgets);
      expect(find.text('More'), findsWidgets);
    });

    testWidgets('should render with FAB', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsWidgets);
    });
  });
}
