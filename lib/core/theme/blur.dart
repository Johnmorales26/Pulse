import "package:flutter/foundation.dart";

/// Centralised blur constants for the Pulse overlay system.
///
/// All helpers in [AppBlur] consume these values as defaults.
/// Callers SHALL NOT construct an instance — use the static
/// members directly, e.g. `AppBlur.sigmaDefault`.
@immutable
final class AppBlur {
  const AppBlur._();

  /// Default blur sigma applied to every overlay.
  static const double sigmaDefault = 5.0;

  /// Minimum permitted sigma (WCAG & performance floor).
  static const double sigmaMin = 5.0;

  /// Maximum permitted sigma (performance ceiling).
  static const double sigmaMax = 8.0;

  /// Default body opacity (light mode) before WCAG clamping.
  static const double bodyOpacityDefault = 0.75;

  /// Default barrier opacity applied to [ColorScheme.scrim].
  static const double barrierOpacityDefault = 0.15;

  /// WCAG AA minimum modal-card opacity (≥85 %).
  static const double wcagMinimumOpacity = 0.85;
}
