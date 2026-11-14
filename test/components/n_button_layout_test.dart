import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/nui_flutter.dart';

void main() {
  testWidgets('a long label wraps instead of overflowing a narrow button',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NTheme.lightTheme(),
        home: Material(
          child: Center(
            child: SizedBox(
              width: 140,
              child: NButton(
                label: 'Ajouter une dépense au groupe',
                leading: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Ajouter une dépense au groupe'), findsOneWidget);
  });
}
