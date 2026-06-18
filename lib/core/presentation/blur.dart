// Shared blur utilities for Pulse overlays.
//
// Re-exports [AppBlur] constants from the theme layer and
// provides WCAG-aware clamp helpers that every overlay
// MUST use before configuring a [BackdropFilter] or body
// opacity.  Callers import this file, never the underlying
// theme constant file directly.

import "package:pulse/core/theme/blur.dart";

export "package:pulse/core/theme/blur.dart" show AppBlur;

/// Clamp blur sigma to the allowed range.
///
/// Values below [AppBlur.sigmaMin] are raised to the minimum;
/// values above [AppBlur.sigmaMax] are capped.  This protects
/// both WCAG legibility and low-end GPU performance.
double clampSigma(double value) =>
    value.clamp(AppBlur.sigmaMin, AppBlur.sigmaMax);

/// Clamp body opacity to the WCAG AA floor.
///
/// Values below [AppBlur.wcagMinimumOpacity] are raised to 0.85.
/// The upper bound is always 1.0 (fully opaque).  Callers never
/// receive a translucent body that fails the minimum-contrast
/// threshold.
double clampBodyOpacity(double value) =>
    value.clamp(AppBlur.wcagMinimumOpacity, 1.0);
