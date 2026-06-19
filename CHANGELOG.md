# Changelog

## 2026-06-18

### Added

- Add `AppBlur` constants and shared `clampSigma` / `clampBodyOpacity` utilities under `lib/core/theme/` and `lib/core/presentation/`.
- Add `showBlurredDialog` and `showBlurredModalBottomSheet` helpers with WCAG-aware body opacity and theme-derived barrier tint.
- Add `bottomSheetTheme` and `dialogTheme` to `MaterialTheme` for translucent overlays.

### Changed

- Replace deprecated `colorScheme.background` with `colorScheme.surface` in `scaffoldBackgroundColor`.
- Migrate 5 bottom-sheet callsites (map filter, profile image picker, saved places, add-place category, place-detail map picker) to `showBlurredModalBottomSheet`.

## 2026-06-17

### Added

- Add category filters to the map with selectable location types.
- Add a filter bottom sheet with category icons and selected-state feedback.
- Keep the user location pin separate from filtered place markers.

### Changed

- Refresh location and launcher assets for the updated map experience.
- Update theme colors and shared tile styling for the refreshed UI.
