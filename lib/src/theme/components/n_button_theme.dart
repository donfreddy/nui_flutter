import 'package:flutter/material.dart';

/// A [ThemeExtension] that controls the visual defaults for [NButton].
///
/// Register this extension through [NTheme.lightTheme] or [NTheme.darkTheme].
/// A default instance is always registered automatically; override individual
/// fields by passing a custom [NButtonTheme] in the `extensions` list:
///
/// ```dart
/// NTheme.lightTheme(
///   palette: myPalette,
///   extensions: [
///     NButtonTheme(radius: 4.0, loadingIcon: LucideIcons.loaderCircle),
///   ],
/// )
/// ```
class NButtonTheme extends ThemeExtension<NButtonTheme> {
  /// An optional icon to display while [NButton.loading] is true.
  ///
  /// Defaults to [LucideIcons.loader] when not set.
  final IconData? loadingIcon;

  /// The corner radius applied to buttons that do not use [NButton.roundedFull].
  ///
  /// Defaults to 8.0 dp.
  final double radius;

  /// Creates an [NButtonTheme].
  ///
  /// [radius] defaults to 8.0 dp.
  const NButtonTheme({
    this.loadingIcon,
    this.radius = 8.0,
  });

  /// Returns a copy of this theme with the given fields replaced.
  @override
  NButtonTheme copyWith({IconData? loadingIcon, double? radius}) {
    return NButtonTheme(
      loadingIcon: loadingIcon ?? this.loadingIcon,
      radius: radius ?? this.radius,
    );
  }

  /// Linearly interpolates between this theme and [other] by [t].
  @override
  NButtonTheme lerp(ThemeExtension<NButtonTheme>? other, double t) {
    if (other is! NButtonTheme) return this;
    return NButtonTheme(
      loadingIcon: loadingIcon ?? other.loadingIcon,
      radius: radius + (other.radius - radius) * t,
    );
  }
}
