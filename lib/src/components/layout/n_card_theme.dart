import 'package:flutter/material.dart';

/// A [ThemeExtension] that controls the visual defaults for [NCard].
///
/// Register this extension through [NTheme.lightTheme] or [NTheme.darkTheme].
/// A default instance is always registered automatically; override individual
/// fields by passing a custom [NCardTheme] in the `extensions` list:
///
/// ```dart
/// NTheme.lightTheme(
///   palette: myPalette,
///   extensions: [
///     NCardTheme(borderRadius: BorderRadius.circular(16)),
///   ],
/// )
/// ```
class NCardTheme extends ThemeExtension<NCardTheme> {
  /// Overrides the default corner radius for all [NCard] instances.
  ///
  /// When `null`, [NCard] falls back to [NTokens.radiusDefault].
  final BorderRadius? borderRadius;

  /// Overrides the default inner padding for all [NCard] sections.
  ///
  /// When `null`, [NCard] uses `EdgeInsets.all(NTokens.paddingDefault)`.
  final EdgeInsetsGeometry? padding;

  /// Creates an [NCardTheme].
  const NCardTheme({this.borderRadius, this.padding});

  @override
  NCardTheme copyWith(
      {BorderRadius? borderRadius, EdgeInsetsGeometry? padding}) {
    return NCardTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  NCardTheme lerp(ThemeExtension<NCardTheme>? other, double t) {
    if (other is! NCardTheme) return this;
    return NCardTheme(
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
      padding: t < 0.5 ? padding : other.padding,
    );
  }
}
