# Design: Custom Floating Map Bar

## Technical Approach

Replace the existing 3 FABs in `MapScreen`'s bottom-right `SafeArea` column with a single horizontal `FloatingMapActionBar` widget positioned at the bottom of the map `Stack` via `Positioned`. The bar uses `Positioned(bottom: 32.0, left: 24.0, right: 24.0)` wrapped in `SafeArea`, with a `Row` of 3 `IconButton`s (search, filter, my-location). Each button dispatches the same existing `MapIntent`s that the current FABs already trigger. The `LocationCard` bottom padding is adjusted from `80.0` to `120.0` to prevent overlap with the new bar.

## Architecture Decisions

### Decision: Extract to dedicated widget vs inline in MapScreen

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Extract `FloatingMapActionBar` widget | +Separation of concerns, testable in isolation, reusable. -One more file. | **Extract** |
| Inline in MapScreen | +Fewer files. -MapScreen already 232 lines, harder to read. | Rejected |

**Rationale**: MapScreen is already a large `Stack` with 5 children. Extracting keeps the screen readable and allows the bar to be unit-tested independently.

### Decision: Positioned vs Align for bar placement

| Option | Tradeoff | Decision |
|--------|----------|----------|
| `Positioned` with explicit left/right/bottom | +Precise control, matches spec (24px margins, 32px bottom). | **Positioned** |
| `Align` with padding | +Simpler. -Less precise on varying screen widths. | Rejected |

**Rationale**: The spec requires exact margins (`left: 24.0, right: 24.0, bottom: 32.0`). `Positioned` gives deterministic layout.

### Decision: IconButton vs FloatingActionButton for bar buttons

| Option | Tradeoff | Decision |
|--------|----------|----------|
| `IconButton` with custom styling | +Lightweight, fits pill container, no built-in elevation/shadow conflicts. | **IconButton** |
| Mini `FloatingActionButton` | +Built-in Material elevation. -Circular shape conflicts with pill bar, adds visual noise. | Rejected |

**Rationale**: The bar is a single pill container (`BorderRadius.circular(30)`) with its own shadow. Individual FABs would create competing elevation surfaces.

## Data Flow

```
    User Tap
       │
       ▼
  FloatingMapActionBar
       │
       ├── [Search Icon] ──→ _showSearchBottomSheet(context)
       │                          │
       │                          └── MapSearchBottomSheet (existing)
       │
       ├── [Filter Icon] ──→ _showFilterBottomSheet(context)
       │                          │
       │                          └── MapFilterBottomSheet (existing)
       │                          └── ToggleMapFilterIntent (existing)
       │
       └── [Location Icon] ──→ FetchUserLocationIntent (existing)
                                    │
                                    └── MapBloc (existing handler)
```

The bar is a **pure UI layer** — it reads `MapState` via `BlocBuilder` for filter active state, and dispatches existing intents. No new bloc logic needed.

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/features/map/presentation/widgets/floating_map_action_bar.dart` | Create | New widget: horizontal pill bar with 3 icon buttons, reads `MapState` for filter indicator |
| `lib/features/map/presentation/map_screen.dart` | Modify | Remove 3 FABs column (lines 74-120), add `FloatingMapActionBar` as a `Stack` child. Adjust `LocationCard` padding from `bottom: 80.0` to `bottom: 120.0` |

## Interfaces / Contracts

### FloatingMapActionBar widget

```dart
class FloatingMapActionBar extends StatelessWidget {
  const FloatingMapActionBar({
    super.key,
    required this.onSearch,
    required this.onFilter,
    required this.onLocation,
    required this.isFilterActive,
  });

  final VoidCallback onSearch;
  final VoidCallback onFilter;
  final VoidCallback onLocation;
  final bool isFilterActive;
}
```

### Visual contract

- Container: `Container` with `decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(30), boxShadow: [...])`
- Row: `MainAxisAlignment.spaceEvenly`, 3 `IconButton`s with `tooltip` from `AppLocalizations`
- Filter icon: `Icons.filter_list` (active) / `Icons.filter_list_outlined` (inactive)
- Search icon: `Icons.search`
- Location icon: `Icons.my_location_outlined`

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | `FloatingMapActionBar` renders 3 buttons, filter icon toggles | Widget test with `pumpWidget`, verify icon presence and `onPressed` callbacks |
| Unit | Bar does not absorb map gestures | Verify bar uses `Positioned` not full-screen overlay |
| Integration | Tapping search opens `MapSearchBottomSheet` | Integration test with `MapScreen` + mock `MapBloc` |
| Integration | Tapping filter opens `MapFilterBottomSheet` and dispatches `ToggleMapFilterIntent` | Integration test verifying bottom sheet visibility and bloc state change |
| Integration | Location card does not overlap bar | Verify `LocationCard` bottom padding >= bar height + gap |

## Migration / Rollout

No migration required. This is a pure UI replacement — no data migration, no feature flags, no API changes. The existing intents and bloc handlers remain unchanged.

## Open Questions

- [ ] Should the bar auto-hide on scroll/zoom like some map apps, or stay always visible? (Current spec: always visible)
- [ ] Any accessibility concerns with icon-only buttons for screen readers? (Tooltips are set, but `Semantics` labels may need verification)
