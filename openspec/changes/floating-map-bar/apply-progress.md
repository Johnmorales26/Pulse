# Apply Progress: floating-map-bar

**Date**: 2026-06-19
**Mode**: Standard (no strict TDD)
**Workload**: Single PR (within 400-line budget)

## Completed Tasks

| # | Task | Status |
|---|------|--------|
| 1.1 | Create FloatingMapActionBar widget file | ✅ |
| 1.2 | Build pill container with surfaceContainerHighest | ✅ |
| 1.3 | Add Row with 3 IconButtons | ✅ |
| 1.4 | Add Semantics labels + tooltips | ✅ |
| 2.1 | Remove old FABs column from MapScreen | ✅ |
| 2.2 | Add Positioned + SafeArea wrapping bar | ✅ |
| 2.3 | Wire callbacks (search, filter, location) | ✅ |
| 2.4 | Pass isFilterActive from BlocBuilder | ✅ |
| 2.5 | Adjust LocationCard bottom padding to 120.0 | ✅ |
| 3.1 | Write test: renders 3 buttons | ✅ |
| 3.2 | Write test: filter icon toggles | ✅ |
| 3.3 | Write test: callbacks fire | ✅ |
| 3.4 | Write test: Semantics labels | ✅ |
| 3.5 | Run flutter test | ⬜ (environment limitation - WSL interop) |

## Files Changed

| File | Action | Description |
|------|--------|-------------|
| `lib/features/map/presentation/widgets/floating_map_action_bar.dart` | Created | New widget: horizontal pill bar with 3 icon buttons |
| `lib/features/map/presentation/map_screen.dart` | Modified | Replaced 3 FABs column with Positioned+FloatingMapActionBar. Adjusted LocationCard padding |
| `test/features/map/presentation/widgets/floating_map_action_bar_test.dart` | Created | 6 widget tests covering rendering, icon toggle, callbacks, Semantics |

## Deviations from Design

None — implementation matches design.

## Issues Found

- **Environment**: Windows Flutter SDK in WSL with CRLF issues in tool scripts (fixed). The flutter tool cannot bootstrap because `dart run` has WSL interop path resolution issues. All code passes `dart analyze` with zero errors. Task 3.5 (`flutter test`) requires a fully bootstrapped Flutter SDK to execute.
- **Design reference**: Task 2.4 mentions `_buildMapActions` which doesn't exist in the codebase. Used a dedicated `BlocBuilder<MapBloc, MapState>` wrapping the `Positioned`+`FloatingMapActionBar` instead, which achieves the same outcome.

## Remaining Tasks

- [ ] 3.5 Run `flutter test` and confirm all existing + new tests pass (requires working Flutter SDK)
