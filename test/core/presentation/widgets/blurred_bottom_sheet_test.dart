import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse/core/presentation/widgets/blurred_bottom_sheet.dart';
import 'package:pulse/core/presentation/blur.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Pump the button that opens the blurred bottom sheet, tap it,
  /// and settle the animation.
  Future<void> openSheet(
    WidgetTester tester, {
    double? bodyOpacity,
    Color? bodyColor,
    double? sigma,
    BorderRadius? borderRadius,
    bool enableDrag = true,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              key: const Key('open-sheet'),
              onPressed: () => showBlurredModalBottomSheet(
                context: context,
                child: const Text('Sheet body'),
                bodyOpacity: bodyOpacity ?? AppBlur.bodyOpacityDefault,
                bodyColor: bodyColor,
                sigma: sigma ?? AppBlur.sigmaDefault,
                borderRadius: borderRadius,
                enableDrag: enableDrag,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-sheet')));
    await tester.pumpAndSettle();
  }

  /// Find the body [Material] — the one whose [Material.borderRadius]
  /// is not `null` (both helpers set an explicit radius on the body).
  Finder findBodyMaterial() {
    return find.byWidgetPredicate(
      (widget) => widget is Material && widget.borderRadius != null,
    );
  }

  // ---------------------------------------------------------------------------
  // Tests
  // ---------------------------------------------------------------------------

  group('showBlurredModalBottomSheet', () {
    testWidgets('renders BackdropFilter', (WidgetTester tester) async {
      await openSheet(tester);

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders child widget', (WidgetTester tester) async {
      await openSheet(tester);

      expect(find.text('Sheet body'), findsOneWidget);
    });

    testWidgets('bodyOpacity 0.5 clamps to WCAG floor 0.85',
        (WidgetTester tester) async {
      await openSheet(tester, bodyOpacity: 0.5);

      final material = tester.widget<Material>(findBodyMaterial());
      // Alpha of the body colour must be ≥ WCAG minimum.
      expect(material.color, isNotNull);
      expect(material.color!.a, greaterThanOrEqualTo(AppBlur.wcagMinimumOpacity));
    });

    testWidgets('drag handle visible by default', (WidgetTester tester) async {
      await openSheet(tester);

      // The drag handle is a Container whose BoxDecoration has a rounded
      // border-radius of 2 and a non-null colour — unique in the sheet tree.
      final dragHandle = find.byWidgetPredicate(
        (widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration &&
              decoration.borderRadius == BorderRadius.circular(2) &&
              decoration.color != null;
        },
      );

      expect(dragHandle, findsOneWidget);
    });

    testWidgets('drag handle hidden when enableDrag is false',
        (WidgetTester tester) async {
      await openSheet(tester, enableDrag: false);

      // No Container with the drag-handle decoration should remain.
      final dragHandle = find.byWidgetPredicate(
        (widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration &&
              decoration.borderRadius == BorderRadius.circular(2) &&
              decoration.color != null;
        },
      );
      expect(dragHandle, findsNothing);
    });

    testWidgets('elevation is 0', (WidgetTester tester) async {
      await openSheet(tester);

      // The body Material should have elevation: 0 — the blur provides
      // visual separation, so Material elevation must be locked at 0.
      final material = tester.widget<Material>(findBodyMaterial());
      expect(material.elevation, 0.0);
    });

    testWidgets('barrier color derives from ColorScheme.scrim with alpha 0.15',
        (WidgetTester tester) async {
      await openSheet(tester);

      // The sheet's child Text lives inside the bottom sheet route.
      final BuildContext sheetChildContext =
          tester.element(find.text('Sheet body'));
      final ColorScheme colorScheme = Theme.of(sheetChildContext).colorScheme;
      final ModalRoute<dynamic> route =
          ModalRoute.of<dynamic>(sheetChildContext)!;

      // The route's barrierColor must be derived from
      // ColorScheme.scrim.withValues(alpha: barrierOpacityDefault).
      expect(
        route.barrierColor,
        equals(
          colorScheme.scrim.withValues(alpha: AppBlur.barrierOpacityDefault),
        ),
      );
    });

    testWidgets('default borderRadius is 20 px top corners',
        (WidgetTester tester) async {
      await openSheet(tester);

      final material = tester.widget<Material>(findBodyMaterial());
      expect(material.borderRadius,
          const BorderRadius.vertical(top: Radius.circular(20)));
    });

    testWidgets('custom borderRadius overrides default',
        (WidgetTester tester) async {
      const custom = BorderRadius.vertical(top: Radius.circular(24));
      await openSheet(tester, borderRadius: custom);

      final material = tester.widget<Material>(findBodyMaterial());
      expect(material.borderRadius, custom);
    });

    testWidgets('bodyColor overrides derived colour',
        (WidgetTester tester) async {
      const override = Color(0xCCFF0000); // red ~80 %
      await openSheet(tester, bodyColor: override);

      final material = tester.widget<Material>(findBodyMaterial());
      expect(material.color, override);
    });
  });
}
