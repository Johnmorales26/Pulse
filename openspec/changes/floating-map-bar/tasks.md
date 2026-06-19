# Tasks: Custom Floating Map Bar

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~200 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | single PR |
| Delivery strategy | ask-on-risk |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

## Phase 1: Core Widget

- [x] 1.1 Create `lib/features/map/presentation/widgets/floating_map_action_bar.dart` with `FloatingMapActionBar` StatelessWidget, 4 params: `onSearch`, `onFilter`, `onLocation`, `isFilterActive`
- [x] 1.2 Build pill container: `surfaceContainerHighest` bg, `BorderRadius.circular(30)`, soft box shadow
- [x] 1.3 Add `Row(MainAxisAlignment.spaceEvenly)` with 3 `IconButton`s: search, filter (active/outlined variant), my-location
- [x] 1.4 Add `Semantics` labels + tooltips from `AppLocalizations` for each button (accessibility requirement)

## Phase 2: Integration Into MapScreen

- [x] 2.1 In `lib/features/map/presentation/map_screen.dart`, remove the 3 FABs column (lines ~74-120)
- [x] 2.2 Add `Positioned(bottom: 32.0, left: 24.0, right: 24.0)` with `SafeArea` wrapping `FloatingMapActionBar` as a new `Stack` child
- [x] 2.3 Wire callbacks: search → `_showSearchBottomSheet`, filter → `_showFilterBottomSheet`, location → `FetchUserLocationIntent` via `context.read<MapBloc>().add()`
- [x] 2.4 Pass `isFilterActive` from `MapState` via existing `BlocBuilder` in `_buildMapActions`
- [x] 2.5 Adjust `LocationCard` bottom padding from `80.0` to `120.0` to prevent overlap

## Phase 3: Tests

- [x] 3.1 Write widget test: `FloatingMapActionBar` renders 3 buttons with correct icons
- [x] 3.2 Write widget test: `isFilterActive` toggles filter icon between filled and outlined
- [x] 3.3 Write widget test: each `onPressed` callback fires the corresponding `VoidCallback`
- [x] 3.4 Write widget test: bar uses `Semantics` labels on each icon button
- [ ] 3.5 Run `flutter test` and confirm all existing + new tests pass
