import 'package:flutter/material.dart';

/// A [ThemeExtension] that provides a custom font family for the NUI text theme.
///
/// Pass an instance to [NTheme.lightTheme] or [NTheme.darkTheme] to apply a
/// custom typeface across all text styles:
///
/// ```dart
/// NTheme.lightTheme(
///   palette: myPalette,
///   typography: NTypography(fontFamily: 'Inter'),
/// )
/// ```
class NTypography extends ThemeExtension<NTypography> {
  /// The font family name applied to all text styles in the theme.
  ///
  /// When `null`, Flutter's default platform font is used.
  final String? fontFamily;

  /// Creates an [NTypography] with an optional [fontFamily].
  const NTypography({this.fontFamily});

  /// Returns a [TextTheme] with [fontFamily] applied, falling back to the
  /// platform default if [fontFamily] is `null`.
  TextTheme resolveTextTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;
    if (fontFamily == null) return base;
    return base.apply(fontFamily: fontFamily);
  }

  /// Returns a copy of this typography with [fontFamily] replaced.
  @override
  NTypography copyWith({String? fontFamily}) {
    return NTypography(fontFamily: fontFamily ?? this.fontFamily);
  }

  /// Linearly interpolates between this typography and [other] by [t].
  ///
  /// The font family switches to [other.fontFamily] once [t] crosses 0.5.
  @override
  NTypography lerp(ThemeExtension<NTypography>? other, double t) {
    if (other is! NTypography) return this;
    return NTypography(fontFamily: t < 0.5 ? fontFamily : other.fontFamily);
  }
}
