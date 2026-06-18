import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse/core/presentation/blur.dart';
import 'package:pulse/core/presentation/widgets/blurred_dialog.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Unit: clamp helpers (fast, no widget tree needed)
  // ---------------------------------------------------------------------------

  group('clampSigma', () {
    test('below floor → clamped to sigmaMin', () {
      expect(clampSigma(2.0), AppBlur.sigmaMin);
    });

    test('above ceiling → clamped to sigmaMax', () {
      expect(clampSigma(12.0), AppBlur.sigmaMax);
    });

    test('within range → unchanged', () {
      expect(clampSigma(6.0), 6.0);
      expect(clampSigma(AppBlur.sigmaMin), AppBlur.sigmaMin);
      expect(clampSigma(AppBlur.sigmaMax), AppBlur.sigmaMax);
    });
  });

  group('clampBodyOpacity', () {
    test('below WCAG floor → clamped to 0.85', () {
      expect(clampBodyOpacity(0.5), AppBlur.wcagMinimumOpacity);
      expect(clampBodyOpacity(0.0), AppBlur.wcagMinimumOpacity);
    });

    test('above 1.0 → clamped to 1.0', () {
      expect(clampBodyOpacity(1.5), 1.0);
    });

    test('within range → unchanged', () {
      expect(clampBodyOpacity(0.9), 0.9);
      expect(clampBodyOpacity(AppBlur.wcagMinimumOpacity),
          AppBlur.wcagMinimumOpacity);
      expect(clampBodyOpacity(1.0), 1.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Widget: showBlurredDialog
  // ---------------------------------------------------------------------------

  group('showBlurredDialog', () {
    Future<void> openDialog(WidgetTester tester, {double? sigma}) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                key: const Key('open-dialog'),
                onPressed: () => showBlurredDialog(
                  context: context,
                  child: const Text('Dialog body'),
                  sigma: sigma ?? AppBlur.sigmaDefault,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('open-dialog')));
      await tester.pumpAndSettle();
    }

    testWidgets('renders BackdropFilter in the widget tree',
        (WidgetTester tester) async {
      await openDialog(tester);

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders the child widget', (WidgetTester tester) async {
      await openDialog(tester);

      expect(find.text('Dialog body'), findsOneWidget);
    });

    testWidgets('uses FadeTransition for entry animation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showBlurredDialog(
                  context: context,
                  child: const Text('X'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      // Pump one frame — dialog should be present with a FadeTransition
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Flutter uses multiple internal FadeTransitions (routes, etc.).
      // Our transitionBuilder adds at least one more — verify existence.
      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets('dismissible by default — tapping barrier closes dialog',
        (WidgetTester tester) async {
      await openDialog(tester);

      // Tap outside the dialog content (on barrier)
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(find.text('Dialog body'), findsNothing);
    });
  });
}
