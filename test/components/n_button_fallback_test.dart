import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/src/components/button/n_button.dart';
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
  final palette = NColorPalette.light(
    primary: Colors.blue,
    secondary: Colors.grey,
    success: Colors.green,
    error: Colors.red,
  );

  testWidgets('NButton renders without NButtonTheme registered',
      (tester) async {
    await _initScreenUtil(tester);
    final theme = NTheme.lightTheme(palette: palette);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(body: NButton(label: 'Test', onPressed: null)),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('NButton with onPressed fires callback', (tester) async {
    await _initScreenUtil(tester);
    var pressed = false;
    final theme = NTheme.lightTheme(palette: palette);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: NButton(label: 'Press', onPressed: () => pressed = true)),
      ),
    );
    await tester.tap(find.text('Press'));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });
}
