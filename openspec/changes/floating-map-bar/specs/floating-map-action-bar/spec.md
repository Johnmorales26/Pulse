# Floating Map Action Bar Specification

## Purpose

Defines the floating action bar overlaid on the map screen, exposing search, filter, and locate-me actions while preserving map gestures elsewhere.

## Requirements

### Requirement: Floating Bar Placement

The map screen SHALL render a single horizontal bar at the bottom via `Positioned` in the existing map `Stack`. The bar MUST sit above the map so gestures work in uncovered areas. Position: `bottom: 32.0, left: 24.0, right: 24.0`. Wrapped in `SafeArea`. Row uses `MainAxisAlignment.spaceEvenly`.

#### Scenario: Bar floats above full-screen map

- GIVEN the map screen is rendered
- WHEN the user views the screen
- THEN the map occupies the full screen
- AND a floating bar is visible at the bottom with 24px horizontal margins

#### Scenario: Bar respects bottom safe area

- GIVEN a device with a bottom safe area inset
- WHEN the bar is rendered
- THEN the bar MUST sit above the inset
- AND the map MUST remain visible behind the bar area

### Requirement: Action Buttons

The bar SHALL contain exactly three icon buttons: search, filter, my-location. Each MUST trigger the corresponding map intent and SHOULD expose a tooltip. The filter button SHALL indicate active filter state.

#### Scenario: User opens search

- GIVEN the bar is visible
- WHEN the user taps the search icon
- THEN the search bottom sheet SHALL open
- AND the map MUST NOT pan or zoom

#### Scenario: User opens filter

- GIVEN the bar is visible
- WHEN the user taps the filter icon
- THEN the filter bottom sheet SHALL open
- AND the map MUST remain visually stable

#### Scenario: Filter icon reflects active state

- GIVEN a category filter is active
- WHEN the bar renders the filter icon
- THEN it SHALL show the active variant
- AND inactive state SHALL use the outlined variant

#### Scenario: User centers on current location

- GIVEN location services are enabled
- WHEN the user taps the my-location icon
- THEN the map camera SHALL animate to the user's location

### Requirement: Visual Treatment

The bar SHALL be visually distinct using a rounded pill, solid surface color, and soft drop shadow. The bar MUST be opaque.

Shape: `BorderRadius.circular(30)`. Surface: `theme.colorScheme.surfaceContainerHighest`. Elevation: soft `boxShadow`, low-opacity shadow color.

#### Scenario: Bar appears as a rounded floating pill

- GIVEN the map screen is rendered
- WHEN the bar is rendered
- THEN it SHALL show rounded ends and a drop shadow
- AND the background MUST be fully opaque

### Requirement: Gesture Transparency Outside the Bar

The map MUST remain interactive outside the bar's hit region. The bar MUST NOT use a full-screen absorbing overlay.

#### Scenario: Pan gesture works outside the bar

- GIVEN the bar is at the bottom
- WHEN the user pans anywhere outside the bar
- THEN the map SHALL respond with the pan gesture

#### Scenario: Tap on bar reaches a button

- GIVEN the user taps inside the bar
- WHEN the tap lands on a button
- THEN the action SHALL fire
- AND the map SHALL NOT pan or zoom

### Requirement: No Overlap With Location Card

When the location card is visible, it MUST NOT be occluded by the bar. The card's bottom inset SHALL be adjusted to sit above the bar.

#### Scenario: Location card remains visible

- GIVEN a location is selected and the card is shown
- WHEN the screen is rendered
- THEN the card's bottom edge SHALL sit above the bar
- AND no part of the card SHALL be hidden

### Requirement: No External Dependencies

The implementation MUST rely solely on Flutter Material widgets and the existing app theme. It MUST NOT introduce new third-party packages.

#### Scenario: No new dependencies

- GIVEN the change is implemented
- WHEN `pubspec.yaml` is inspected
- THEN no new third-party packages SHALL be added
