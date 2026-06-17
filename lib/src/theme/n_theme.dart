import 'package:flutter/material.dart';
import 'n_color_palette.dart';
import 'n_color_mapping.dart';
import 'n_typography.dart';
import '../components/button/n_button_theme.dart';
import '../components/forms/n_input_theme.dart';
import '../components/layout/n_card_theme.dart';

/// Factory class for building a [ThemeData] from an [NColorPalette].
///
/// [NTheme] wires the palette into Flutter's Material 3 color system and
/// registers the default [NButtonTheme] and [NInputTheme] extensions.
/// Use it inside your [MaterialApp] or [CupertinoApp]:
///
/// ```dart
/// MaterialApp(
///   theme: NTheme.lightTheme(palette: MyPalette.light()),
///   darkTheme: NTheme.darkTheme(palette: MyPalette.dark()),
/// );
/// ```
abstract class NTheme {
  /// Builds a Material 3 light [ThemeData] from the given [palette].
  ///
  /// [palette] provides all semantic color tokens for the app.
  /// [radius] is the default corner radius applied to buttons and inputs.
  /// [extensions] allows the app to pass additional or overriding
  /// [ThemeExtension] values. App-supplied extensions replace the defaults
  /// when they share the same [runtimeType].
  static ThemeData lightTheme({
    required NColorPalette palette,
    double radius = 8.0,
    double textScale = 1.0,
    NTypography? typography,
    Iterable<ThemeExtension<dynamic>> extensions = const [],
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: buildColorScheme(palette, Brightness.light),
      scaffoldBackgroundColor: palette.bgDefault,
      cardColor: palette.bgElevated,
      textTheme: buildTextTheme(palette, Brightness.light,
          textScale: textScale, typography: typography),
      extensions: [
        palette,
        NButtonTheme(radius: radius),
        NInputTheme(radius: radius),
        const NCardTheme(),
        if (typography != null) typography,
        ...extensions,
      ],
    );
  }

  /// Builds a Material 3 dark [ThemeData] from the given [palette].
  ///
  /// [palette] provides all semantic color tokens for the app.
  /// [radius] is the default corner radius applied to buttons and inputs.
  /// [extensions] allows the app to pass additional or overriding
  /// [ThemeExtension] values. App-supplied extensions replace the defaults
  /// when they share the same [runtimeType].
  static ThemeData darkTheme({
    required NColorPalette palette,
    double radius = 8.0,
    double textScale = 1.0,
    NTypography? typography,
    Iterable<ThemeExtension<dynamic>> extensions = const [],
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: buildColorScheme(palette, Brightness.dark),
      scaffoldBackgroundColor: palette.bgDefault,
      cardColor: palette.bgElevated,
      textTheme: buildTextTheme(palette, Brightness.dark,
          textScale: textScale, typography: typography),
      extensions: [
        palette,
        NButtonTheme(radius: radius),
        NInputTheme(radius: radius),
        const NCardTheme(),
        if (typography != null) typography,
        ...extensions,
      ],
    );
  }

}
