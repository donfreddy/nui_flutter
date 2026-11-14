import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/nui_flutter.dart';

/// Components tint their text but must keep the app font family from the
/// theme: they merge into the inherited DefaultTextStyle instead of
/// replacing it.
void main() {
  Future<String?> familyOf(
      WidgetTester tester, Widget child, String text) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NTheme.lightTheme(
          typography: const NTypography(fontFamily: 'AppFont'),
        ),
        home: Material(child: child),
      ),
    );
    final rich = tester.widget<RichText>(
      find.descendant(of: find.text(text), matching: find.byType(RichText)),
    );
    return rich.text.style?.fontFamily;
  }

  testWidgets('NCard keeps the inherited font family', (tester) async {
    expect(
        await familyOf(tester, const NCard(child: Text('in card')), 'in card'),
        'AppFont');
  });

  testWidgets('NButton label keeps the inherited font family', (tester) async {
    expect(
      await familyOf(tester, NButton(label: 'ok', onPressed: () {}), 'ok'),
      'AppFont',
    );
  });

  testWidgets('NButton child keeps the inherited font family', (tester) async {
    expect(
      await familyOf(tester,
          NButton(onPressed: () {}, child: const Text('child')), 'child'),
      'AppFont',
    );
  });

  testWidgets('NAlert child keeps the inherited font family', (tester) async {
    expect(
      await familyOf(
          tester, const NAlert(child: Text('alert body')), 'alert body'),
      'AppFont',
    );
  });
}
