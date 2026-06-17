import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff765a0b),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdf9a),
      onPrimaryContainer: Color(0xff5a4300),
      secondary: Color(0xff69548d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffebdcff),
      onSecondaryContainer: Color(0xff503c74),
      tertiary: Color(0xff006a62),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9df2e6),
      onTertiaryContainer: Color(0xff005049),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      onSurfaceVariant: Color(0xff4d4639),
      outline: Color(0xff7f7667),
      outlineVariant: Color(0xffd0c5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe8c26c),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xffe8c26c),
      onPrimaryFixedVariant: Color(0xff5a4300),
      secondaryFixed: Color(0xffebdcff),
      onSecondaryFixed: Color(0xff240e45),
      secondaryFixedDim: Color(0xffd4bbfc),
      onSecondaryFixedVariant: Color(0xff503c74),
      tertiaryFixed: Color(0xff9df2e6),
      onTertiaryFixed: Color(0xff00201d),
      tertiaryFixedDim: Color(0xff81d5ca),
      onTertiaryFixedVariant: Color(0xff005049),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff463300),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff87691c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3f2b62),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff78639d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003e38),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b7a71),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff141109),
      onSurfaceVariant: Color(0xff3c3529),
      outline: Color(0xff595244),
      outlineVariant: Color(0xff746c5d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe8c26c),
      primaryFixed: Color(0xff87691c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6c5100),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff78639d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5f4a83),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b7a71),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006058),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcec5b8),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff0e7d9),
      surfaceContainerHigh: Color(0xffe5dcce),
      surfaceContainerHighest: Color(0xffd9d0c3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a2a00),
      surfaceTint: Color(0xff765a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5d4600),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff352157),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff533f76),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00322e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00534c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff312b1f),
      outlineVariant: Color(0xff4f483b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe8c26c),
      primaryFixed: Color(0xff5d4600),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff423000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff533f76),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3c285e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00534c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003a35),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc0b8ab),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9efe2),
      surfaceContainer: Color(0xffebe1d4),
      surfaceContainerHigh: Color(0xffdcd3c6),
      surfaceContainerHighest: Color(0xffcec5b8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe8c26c),
      surfaceTint: Color(0xffe8c26c),
      onPrimary: Color(0xff3f2e00),
      primaryContainer: Color(0xff5a4300),
      onPrimaryContainer: Color(0xffffdf9a),
      secondary: Color(0xffd4bbfc),
      onSecondary: Color(0xff39255c),
      secondaryContainer: Color(0xff503c74),
      onSecondaryContainer: Color(0xffebdcff),
      tertiary: Color(0xff81d5ca),
      onTertiary: Color(0xff003732),
      tertiaryContainer: Color(0xff005049),
      onTertiaryContainer: Color(0xff9df2e6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff17130b),
      onSurface: Color(0xffebe1d4),
      onSurfaceVariant: Color(0xffd0c5b4),
      outline: Color(0xff999080),
      outlineVariant: Color(0xff4d4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff765a0b),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xffe8c26c),
      onPrimaryFixedVariant: Color(0xff5a4300),
      secondaryFixed: Color(0xffebdcff),
      onSecondaryFixed: Color(0xff240e45),
      secondaryFixedDim: Color(0xffd4bbfc),
      onSecondaryFixedVariant: Color(0xff503c74),
      tertiaryFixed: Color(0xff9df2e6),
      onTertiaryFixed: Color(0xff00201d),
      tertiaryFixedDim: Color(0xff81d5ca),
      onTertiaryFixedVariant: Color(0xff005049),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd87f),
      surfaceTint: Color(0xffe8c26c),
      onPrimary: Color(0xff322300),
      primaryContainer: Color(0xffad8c3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe6d5ff),
      onSecondary: Color(0xff2e1a50),
      secondaryContainer: Color(0xff9c86c3),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff97ebe0),
      onTertiary: Color(0xff002b27),
      tertiaryContainer: Color(0xff499e94),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe6dbc9),
      outline: Color(0xffbbb1a0),
      outlineVariant: Color(0xff988f7f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff5c4400),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff181000),
      primaryFixedDim: Color(0xffe8c26c),
      onPrimaryFixedVariant: Color(0xff463300),
      secondaryFixed: Color(0xffebdcff),
      onSecondaryFixed: Color(0xff19023b),
      secondaryFixedDim: Color(0xffd4bbfc),
      onSecondaryFixedVariant: Color(0xff3f2b62),
      tertiaryFixed: Color(0xff9df2e6),
      onTertiaryFixed: Color(0xff001512),
      tertiaryFixedDim: Color(0xff81d5ca),
      onTertiaryFixedVariant: Color(0xff003e38),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff49443a),
      surfaceContainerLowest: Color(0xff0a0703),
      surfaceContainerLow: Color(0xff211d15),
      surfaceContainer: Color(0xff2c271f),
      surfaceContainerHigh: Color(0xff373229),
      surfaceContainerHighest: Color(0xff423d34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeed0),
      surfaceTint: Color(0xffe8c26c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe3be69),
      onPrimaryContainer: Color(0xff110a00),
      secondary: Color(0xfff6ecff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd0b7f8),
      onSecondaryContainer: Color(0xff120030),
      tertiary: Color(0xffaefff4),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff7dd1c6),
      onTertiaryContainer: Color(0xff000e0c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffaefdc),
      outlineVariant: Color(0xffccc1b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff5c4400),
      primaryFixed: Color(0xffffdf9a),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe8c26c),
      onPrimaryFixedVariant: Color(0xff181000),
      secondaryFixed: Color(0xffebdcff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd4bbfc),
      onSecondaryFixedVariant: Color(0xff19023b),
      tertiaryFixed: Color(0xff9df2e6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff81d5ca),
      onTertiaryFixedVariant: Color(0xff001512),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff554f45),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff231f17),
      surfaceContainer: Color(0xff353027),
      surfaceContainerHigh: Color(0xff403b31),
      surfaceContainerHighest: Color(0xff4c463c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
