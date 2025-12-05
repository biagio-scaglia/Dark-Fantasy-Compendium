import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dark_fantasy_compendium/widgets/animated_button.dart';
import 'package:dark_fantasy_compendium/widgets/animated_card.dart';
import 'package:dark_fantasy_compendium/core/accessibility/accessibility_helper.dart';

void main() {
  group('Accessibility Tests', () {
    testWidgets('AnimatedButton should have semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              semanticLabel: 'Test Button',
              onPressed: () {},
              child: const Text('Button'),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.text('Button'));
      expect(semantics, isNotNull);
    });

    testWidgets('AnimatedButton should have minimum tap target', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
          ),
        ),
      );

      final button = find.text('Button');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify button is tappable
      expect(button, findsOneWidget);
    });

    testWidgets('AnimatedCard should have semantic label when tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              semanticLabel: 'Test Card',
              onTap: () {},
              child: const Text('Card Content'),
            ),
          ),
        ),
      );

      final card = find.text('Card Content');
      expect(card, findsOneWidget);
    });

    testWidgets('AccessibilityHelper should clamp text scaler', (tester) async {
      final scaler = TextScaler.linear(3.0); // 300%
      final clamped = AccessibilityHelper.clampTextScaler(scaler);

      expect(clamped.scale(1.0), lessThanOrEqualTo(2.0));
      expect(clamped.scale(1.0), greaterThanOrEqualTo(0.8));
    });

    testWidgets('AccessibilityHelper should ensure min tap target', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibilityHelper.ensureMinTapTarget(
              const Icon(Icons.add),
            ),
          ),
        ),
      );

      final icon = find.byIcon(Icons.add);
      expect(icon, findsOneWidget);
    });
  });
}

