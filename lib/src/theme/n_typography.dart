import 'package:flutter/material.dart';

class NTypography extends ThemeExtension<NTypography> {
  final String? fontFamily;

  const NTypography({this.fontFamily});

  TextTheme resolveTextTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;
    if (fontFamily == null) return base;
    return base.apply(fontFamily: fontFamily);
  }

  @override
  NTypography copyWith({String? fontFamily}) {
    return NTypography(fontFamily: fontFamily ?? this.fontFamily);
  }

  @override
  NTypography lerp(ThemeExtension<NTypography>? other, double t) {
    if (other is! NTypography) return this;
    return NTypography(fontFamily: t < 0.5 ? fontFamily : other.fontFamily);
  }
}
