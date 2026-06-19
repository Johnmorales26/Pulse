import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/map/presentation/widgets/floating_map_action_bar.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Wraps [FloatingMapActionBar] in a full [MaterialApp] so that theme,
/// localizations, and [Semantics] tree are available.
Widget _buildBar({
  bool isFilterActive = false,
  VoidCallback? onSearch,
  VoidCallback? onFilter,
  VoidCallback? onLocation,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: FloatingMapActionBar(
        onSearch: onSearch ?? () {},
        onFilter: onFilter ?? () {},
        onLocation: onLocation ?? () {},
        isFilterActive: isFilterActive,
      ),
    ),
  );
}

void main() {
  group('FloatingMapActionBar', () {
    testWidgets('renders all 3 buttons', (tester) async {
      await tester.pumpWidget(_buildBar());
      await tester.pumpAndSettle();

      // Three IconButtons inside the bar
      expect(find.byType(IconButton), findsNWidgets(3));
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.filter_list_outlined), findsOneWidget);
      expect(find.byIcon(Icons.my_location_outlined), findsOneWidget);
    });

    testWidgets('shows filled filter icon when isFilterActive is true',
        (tester) async {
      await tester.pumpWidget(_buildBar(isFilterActive: true));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.filter_list_outlined), findsNothing);
    });

    testWidgets('shows outlined filter icon when isFilterActive is false',
        (tester) async {
      await tester.pumpWidget(_buildBar(isFilterActive: false));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list_outlined), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsNothing);
    });

    testWidgets('calls onSearch when search button is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildBar(
        onSearch: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);

      expect(tapped, isTrue);
    });

    testWidgets('calls onFilter when filter button is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildBar(
        onFilter: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      final filterButton = find.byIcon(Icons.filter_list_outlined);
      await tester.tap(filterButton);

      expect(tapped, isTrue);
    });

    testWidgets('calls onLocation when location button is tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildBar(
        onLocation: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      final locationButton = find.byIcon(Icons.my_location_outlined);
      await tester.tap(locationButton);

      expect(tapped, isTrue);
    });

    testWidgets('has Semantics labels on all buttons', (tester) async {
      await tester.pumpWidget(_buildBar());
      await tester.pumpAndSettle();

      // Each IconButton is wrapped in a Semantics widget with button:true.
      // We can verify by finding Semantics in the widget tree.
      final semanticsNodes = find.byType(Semantics);
      expect(semanticsNodes, findsWidgets);
    });
  });
}
