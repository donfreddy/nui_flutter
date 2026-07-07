import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';
import 'n_color_mapping.dart';
import 'components/n_card_theme.dart';

/// Factory class for building a [ThemeData] from an [NColors].
///
/// [NTheme] wires the palette into Flutter's Material 3 color system and
/// registers the default [NButtonTheme] and [NInputTheme] extensions.
/// Use it inside your [MaterialApp] or [CupertinoApp]:
///
/// ```dart
/// MaterialApp(
///   theme: NTheme.lightTheme(colors: MyPalette.light()),
///   darkTheme: NTheme.darkTheme(colors: MyPalette.dark()),
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
    NColors? colors,
    double radius = 8.0,
    double textScale = 1.0,
    NTypography? typography,
    NRadius? radiusScale,
    Iterable<ThemeExtension<dynamic>> extensions = const [],
  }) {
    final resolvedColors = colors ?? NColors.light();
    final nRadius = radiusScale ?? NRadius(base: radius);
    final Map<Object, ThemeExtension<dynamic>> extMap = {
      resolvedColors.runtimeType: resolvedColors,
      nRadius.runtimeType: nRadius,
      NShadows.light().runtimeType: NShadows.light(),
      NButtonTheme(radius: nRadius.md).runtimeType:
          NButtonTheme(radius: nRadius.md),
      NInputTheme(radius: nRadius.md).runtimeType:
          NInputTheme(radius: nRadius.md),
      const NCardTheme().runtimeType: const NCardTheme(),
      if (typography != null) typography.runtimeType: typography,
      for (final e in extensions) e.runtimeType: e,
    };
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: buildColorScheme(resolvedColors, Brightness.light),
      scaffoldBackgroundColor: resolvedColors.bg,
      cardColor: resolvedColors.bgElevated,
      textTheme: buildTextTheme(resolvedColors, Brightness.light,
          textScale: textScale, typography: typography),
      extensions: extMap.values.toList(),
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
    NColors? colors,
    double radius = 8.0,
    double textScale = 1.0,
    NTypography? typography,
    NRadius? radiusScale,
    Iterable<ThemeExtension<dynamic>> extensions = const [],
  }) {
    final resolvedColors = colors ?? NColors.dark();
    final nRadius = radiusScale ?? NRadius(base: radius);
    final Map<Object, ThemeExtension<dynamic>> extMap = {
      resolvedColors.runtimeType: resolvedColors,
      nRadius.runtimeType: nRadius,
      NShadows.dark().runtimeType: NShadows.dark(),
      NButtonTheme(radius: nRadius.md).runtimeType:
          NButtonTheme(radius: nRadius.md),
      NInputTheme(radius: nRadius.md).runtimeType:
          NInputTheme(radius: nRadius.md),
      const NCardTheme().runtimeType: const NCardTheme(),
      if (typography != null) typography.runtimeType: typography,
      for (final e in extensions) e.runtimeType: e,
    };
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: buildColorScheme(resolvedColors, Brightness.dark),
      scaffoldBackgroundColor: resolvedColors.bg,
      cardColor: resolvedColors.bgElevated,
      textTheme: buildTextTheme(resolvedColors, Brightness.dark,
          textScale: textScale, typography: typography),
      extensions: extMap.values.toList(),
    );
  }
}
