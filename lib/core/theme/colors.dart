import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6d538b),
      surfaceTint: Color(0xff6d538b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffeedbff),
      onPrimaryContainer: Color(0xff543b72),
      secondary: Color(0xff884b6b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffd8e9),
      onSecondaryContainer: Color(0xff6c3453),
      tertiary: Color(0xff1b6585),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc3e8ff),
      onTertiaryContainer: Color(0xff004c68),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff7ff),
      onSurface: Color(0xff1d1a20),
      onSurfaceVariant: Color(0xff4a454e),
      outline: Color(0xff7b757f),
      outlineVariant: Color(0xffccc4cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inversePrimary: Color(0xffd8bafa),
      primaryFixed: Color(0xffeedbff),
      onPrimaryFixed: Color(0xff270d43),
      primaryFixedDim: Color(0xffd8bafa),
      onPrimaryFixedVariant: Color(0xff543b72),
      secondaryFixed: Color(0xffffd8e9),
      onSecondaryFixed: Color(0xff380726),
      secondaryFixedDim: Color(0xfffcb0d6),
      onSecondaryFixedVariant: Color(0xff6c3453),
      tertiaryFixed: Color(0xffc3e8ff),
      onTertiaryFixed: Color(0xff001e2c),
      tertiaryFixedDim: Color(0xff8fcff3),
      onTertiaryFixedVariant: Color(0xff004c68),
      surfaceDim: Color(0xffdfd8e0),
      surfaceBright: Color(0xfffff7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f1f9),
      surfaceContainer: Color(0xfff3ebf3),
      surfaceContainerHigh: Color(0xffede6ee),
      surfaceContainerHighest: Color(0xffe8e0e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff432a60),
      surfaceTint: Color(0xff6d538b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7c619b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff592342),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff98597a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003b51),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff2f7495),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7ff),
      onSurface: Color(0xff131015),
      onSurfaceVariant: Color(0xff39343d),
      outline: Color(0xff56505a),
      outlineVariant: Color(0xff716b74),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inversePrimary: Color(0xffd8bafa),
      primaryFixed: Color(0xff7c619b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff634981),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff98597a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7c4161),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff2f7495),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff075b7b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcbc4cc),
      surfaceBright: Color(0xfffff7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f1f9),
      surfaceContainer: Color(0xffede6ee),
      surfaceContainerHigh: Color(0xffe2dbe2),
      surfaceContainerHighest: Color(0xffd6cfd7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff382055),
      surfaceTint: Color(0xff6d538b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff563e74),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4c1937),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6f3656),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003043),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004f6c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2f2a33),
      outlineVariant: Color(0xff4c4750),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff332f35),
      inversePrimary: Color(0xffd8bafa),
      primaryFixed: Color(0xff563e74),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3f275c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6f3656),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff54203e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004f6c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00374c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbdb7be),
      surfaceBright: Color(0xfffff7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6eef6),
      surfaceContainer: Color(0xffe8e0e8),
      surfaceContainerHigh: Color(0xffd9d2da),
      surfaceContainerHighest: Color(0xffcbc4cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd8bafa),
      surfaceTint: Color(0xffd8bafa),
      onPrimary: Color(0xff3d245a),
      primaryContainer: Color(0xff543b72),
      onPrimaryContainer: Color(0xffeedbff),
      secondary: Color(0xfffcb0d6),
      onSecondary: Color(0xff521d3c),
      secondaryContainer: Color(0xff6c3453),
      onSecondaryContainer: Color(0xffffd8e9),
      tertiary: Color(0xff8fcff3),
      onTertiary: Color(0xff003549),
      tertiaryContainer: Color(0xff004c68),
      onTertiaryContainer: Color(0xffc3e8ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff151218),
      onSurface: Color(0xffe8e0e8),
      onSurfaceVariant: Color(0xffccc4cf),
      outline: Color(0xff958e98),
      outlineVariant: Color(0xff4a454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e0e8),
      inversePrimary: Color(0xff6d538b),
      primaryFixed: Color(0xffeedbff),
      onPrimaryFixed: Color(0xff270d43),
      primaryFixedDim: Color(0xffd8bafa),
      onPrimaryFixedVariant: Color(0xff543b72),
      secondaryFixed: Color(0xffffd8e9),
      onSecondaryFixed: Color(0xff380726),
      secondaryFixedDim: Color(0xfffcb0d6),
      onSecondaryFixedVariant: Color(0xff6c3453),
      tertiaryFixed: Color(0xffc3e8ff),
      onTertiaryFixed: Color(0xff001e2c),
      tertiaryFixedDim: Color(0xff8fcff3),
      onTertiaryFixedVariant: Color(0xff004c68),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff3c383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1d1a20),
      surfaceContainer: Color(0xff221e24),
      surfaceContainerHigh: Color(0xff2c292f),
      surfaceContainerHighest: Color(0xff373339),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffead4ff),
      surfaceTint: Color(0xffd8bafa),
      onPrimary: Color(0xff31194e),
      primaryContainer: Color(0xffa185c1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffcfe5),
      onSecondary: Color(0xff441231),
      secondaryContainer: Color(0xffc17c9f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb4e3ff),
      onTertiary: Color(0xff00293a),
      tertiaryContainer: Color(0xff5898ba),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff151218),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe2d9e5),
      outline: Color(0xffb7afba),
      outlineVariant: Color(0xff958e98),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e0e8),
      inversePrimary: Color(0xff553c73),
      primaryFixed: Color(0xffeedbff),
      onPrimaryFixed: Color(0xff1c0139),
      primaryFixedDim: Color(0xffd8bafa),
      onPrimaryFixedVariant: Color(0xff432a60),
      secondaryFixed: Color(0xffffd8e9),
      onSecondaryFixed: Color(0xff2a001b),
      secondaryFixedDim: Color(0xfffcb0d6),
      onSecondaryFixedVariant: Color(0xff592342),
      tertiaryFixed: Color(0xffc3e8ff),
      onTertiaryFixed: Color(0xff00131d),
      tertiaryFixedDim: Color(0xff8fcff3),
      onTertiaryFixedVariant: Color(0xff003b51),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff474349),
      surfaceContainerLowest: Color(0xff09070b),
      surfaceContainerLow: Color(0xff1f1c22),
      surfaceContainer: Color(0xff2a272c),
      surfaceContainerHigh: Color(0xff353137),
      surfaceContainerHighest: Color(0xff403c42),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff8ecff),
      surfaceTint: Color(0xffd8bafa),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd4b6f6),
      onPrimaryContainer: Color(0xff14002d),
      secondary: Color(0xffffebf2),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfff8acd2),
      onSecondaryContainer: Color(0xff1f0013),
      tertiary: Color(0xffe1f2ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff8bcbef),
      onTertiaryContainer: Color(0xff000d15),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff151218),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff6edf8),
      outlineVariant: Color(0xffc8c0cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e0e8),
      inversePrimary: Color(0xff553c73),
      primaryFixed: Color(0xffeedbff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd8bafa),
      onPrimaryFixedVariant: Color(0xff1c0139),
      secondaryFixed: Color(0xffffd8e9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfffcb0d6),
      onSecondaryFixedVariant: Color(0xff2a001b),
      tertiaryFixed: Color(0xffc3e8ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff8fcff3),
      onTertiaryFixedVariant: Color(0xff00131d),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff534f55),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff221e24),
      surfaceContainer: Color(0xff332f35),
      surfaceContainerHigh: Color(0xff3e3a40),
      surfaceContainerHighest: Color(0xff49454c),
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


  List<ExtendedColor> get extendedColors => [
  ];
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
