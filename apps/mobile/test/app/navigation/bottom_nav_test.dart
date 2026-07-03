import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/app/navigation/bottom_nav.dart';

void main() {
  group('AsheeigheNavigationBar', () {
    testWidgets('should render 5 tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('AI Chat'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('should call onTap when tab is pressed', (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('AI Chat'));
      expect(tappedIndex, 1);
    });

    testWidgets('should highlight selected tab', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 2,
              onTap: (index) {},
            ),
          ),
        ),
      );

      // Calendar tab should be selected
      final calendarText = tester.widget<Text>(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == 'Calendar',
        ),
      );
      expect(calendarText.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('should display badge counts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
              badgeCounts: {1: 3, 3: 5},
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should display 99+ for large badge counts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
              badgeCounts: {1: 100},
            ),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('should not render badge for zero count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
              badgeCounts: {1: 0},
            ),
          ),
        ),
      );

      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('should render icons for all tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
      expect(find.byIcon(Icons.checklist_outlined), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz_outlined), findsOneWidget);
    });

    testWidgets('should show active icon for selected tab', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('should be tappable via GestureDetector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsheeigheNavigationBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
