import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/src/components/forms/n_input.dart';
import 'package:nui_flutter/src/theme/n_color_palette.dart';
import 'package:nui_flutter/src/theme/n_theme.dart';

void main() {
  final palette = NColorPalette.light(
    primary: Colors.blue,
    secondary: Colors.grey,
    success: Colors.green,
    error: Colors.red,
  );

  testWidgets('NInput renders without NInputTheme registered', (tester) async {
    final theme = NTheme.lightTheme(palette: palette);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: NInput(label: 'Name', placeholder: 'Enter name'),
        ),
      ),
    );
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Enter name'), findsOneWidget);
  });
}
