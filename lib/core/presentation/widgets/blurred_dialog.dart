import "dart:ui" show ImageFilter;

import "package:flutter/material.dart";

import "package:pulse/core/presentation/blur.dart";

/// Show a theme-aware blurred dialog.
///
/// The barrier colour is derived from [ColorScheme.scrim] at
/// [barrierOpacity] unless [barrierColor] is supplied.  Sigma
/// is clamped to `[5.0, 8.0]`.  Only a linear fade transition
/// is used — no scale, no sigma animation — keeping GPU cost
/// predictable on low-end devices.
///
/// Example:
/// ```dart
/// await showBlurredDialog<bool>(
///   context: context,
///   child: const ConfirmDialog(),
/// );
/// ```
Future<T?> showBlurredDialog<T>({
  required BuildContext context,
  required Widget child,
  double sigma = AppBlur.sigmaDefault,
  double barrierOpacity = AppBlur.barrierOpacityDefault,
  Color? barrierColor,
  bool dismissible = true,
  String? barrierLabel,
}) {
  final clampedSigma = clampSigma(sigma);
  final colorScheme = Theme.of(context).colorScheme;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel:
        barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ??
        colorScheme.scrim.withValues(alpha: barrierOpacity),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: clampedSigma,
            sigmaY: clampedSigma,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                color: colorScheme.surface.withValues(
                  alpha: clampBodyOpacity(AppBlur.bodyOpacityDefault),
                ),
              ),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
