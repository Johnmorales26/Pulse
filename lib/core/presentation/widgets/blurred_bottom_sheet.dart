import "dart:ui" show ImageFilter;

import "package:flutter/material.dart";

import "package:pulse/core/presentation/blur.dart";

/// Show a theme-aware blurred modal bottom sheet.
///
/// The sheet renders over a [BackdropFilter] with a clamped
/// sigma while the body uses a WCAG‑clamped translucent surface.
/// A thin drag handle is visible by default and hidden when
/// [enableDrag] is `false`.
///
/// * [bodyOpacity] is clamped to `≥ 0.85` before the colour is
///   derived from the active [ColorScheme].  Pass [bodyColor] to
///   supply a fully custom tint.
/// * [borderRadius] defaults to 20 px top corners; [elevation] is
///   locked at 0 so the blur provides visual separation.
///
/// Example:
/// ```dart
/// await showBlurredModalBottomSheet<String>(
///   context: context,
///   child: const FilterSheet(),
/// );
/// ```
Future<T?> showBlurredModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  double sigma = AppBlur.sigmaDefault,
  double bodyOpacity = AppBlur.bodyOpacityDefault,
  Color? bodyColor,
  BorderRadius? borderRadius,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  final clampedSigma = clampSigma(sigma);
  final clampedBodyOpacity = clampBodyOpacity(bodyOpacity);
  final colorScheme = Theme.of(context).colorScheme;
  final sheetBorderRadius =
      borderRadius ?? const BorderRadius.vertical(top: Radius.circular(20));

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor:
        colorScheme.scrim.withValues(alpha: AppBlur.barrierOpacityDefault),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: sheetBorderRadius),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: clampedSigma,
          sigmaY: clampedSigma,
        ),
        child: Material(
          color: bodyColor ?? _deriveBodyColor(colorScheme, clampedBodyOpacity),
          borderRadius: sheetBorderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (enableDrag) _DragHandle(colorScheme: colorScheme),
              child,
            ],
          ),
        ),
      );
    },
  );
}

/// Compute the default body colour from the active colour scheme.
///
/// Light-mode produces `surface` at [opacity]; dark-mode produces
/// `onSurface` at [opacity] to yield a tinted-dark translucent layer.
Color _deriveBodyColor(ColorScheme colorScheme, double opacity) {
  if (colorScheme.brightness == Brightness.dark) {
    return colorScheme.onSurface.withValues(alpha: opacity);
  }
  return colorScheme.surface.withValues(alpha: opacity);
}

/// Thin drag handle (40×4 px rounded bar) rendered at the top
/// of the sheet body.
class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.40),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
