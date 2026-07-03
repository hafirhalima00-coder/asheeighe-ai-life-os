import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/features/dashboard/presentation/widgets/insight_card.dart';

void main() {
  group('InsightCard', () {
    testWidgets('should display the insight text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsightCard(insight: 'Stay hydrated and focused today!'),
          ),
        ),
      );

      expect(find.text('AI Insight'), findsOneWidget);
      expect(find.text('Stay hydrated and focused today!'), findsOneWidget);
    });

    testWidgets('should be tappable when onTap is provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsightCard(
              insight: 'Test insight',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).last);
      expect(tapped, true);
    });

    testWidgets('should render without onTap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsightCard(insight: 'Test insight'),
          ),
        ),
      );

      expect(find.text('Test insight'), findsOneWidget);
    });

    testWidgets('should display arrow icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsightCard(insight: 'Test insight'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('should handle long insight text with ellipsis', (tester) async {
      final longText = 'A very long insight ' * 10;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InsightCard(insight: longText),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
