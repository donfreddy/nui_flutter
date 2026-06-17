import 'package:flutter/material.dart';

class NCardTheme extends ThemeExtension<NCardTheme> {
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const NCardTheme({this.borderRadius, this.padding});

  @override
  NCardTheme copyWith({BorderRadius? borderRadius, EdgeInsetsGeometry? padding}) {
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
