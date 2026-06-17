import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/src/components/button/n_button_theme.dart';
import 'package:nui_flutter/src/components/forms/n_input_theme.dart';
import 'package:nui_flutter/src/theme/n_color_palette.dart';
import 'package:nui_flutter/src/theme/n_theme.dart';

Future<void> _initScreenUtil(WidgetTester tester) async {
  await tester.pumpWidget(
    Builder(
      builder: (context) {
        ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true);
        return const SizedBox.shrink();
      },
    ),
  );
}

void main() {
  final testPalette = NColorPalette.light(
    primary: const Color(0xFF000001),
    secondary: const Color(0xFF000002),
    success: const Color(0xFF000003),
    error: const Color(0xFF000004),
  );

  group('NTheme extension merge by type', () {
    testWidgets('app-supplied NButtonTheme overrides default', (tester) async {
      await _initScreenUtil(tester);
      const custom = NButtonTheme(radius: 99.0);
      final theme = NTheme.lightTheme(palette: testPalette, extensions: [custom]);
      final result = theme.extension<NButtonTheme>();
      expect(result, isNotNull);
      expect(result!.radius, equals(99.0));
    });

    testWidgets('app-supplied NInputTheme overrides default', (tester) async {
      await _initScreenUtil(tester);
      const custom = NInputTheme(radius: 42.0);
      final theme = NTheme.lightTheme(palette: testPalette, extensions: [custom]);
      final result = theme.extension<NInputTheme>();
      expect(result, isNotNull);
      expect(result!.radius, equals(42.0));
    });

    testWidgets('default radius is 8.0 when no override', (tester) async {
      await _initScreenUtil(tester);
      final theme = NTheme.lightTheme(palette: testPalette);
      final btnTheme = theme.extension<NButtonTheme>();
      expect(btnTheme!.radius, equals(8.0));
    });

    testWidgets('NColorPalette is registered as extension', (tester) async {
      await _initScreenUtil(tester);
      final theme = NTheme.lightTheme(palette: testPalette);
      final palette = theme.extension<NColorPalette>();
      expect(palette, isNotNull);
      expect(palette!.primary, equals(const Color(0xFF000001)));
    });
  });
}
