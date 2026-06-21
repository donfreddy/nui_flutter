import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nui_flutter_example/main.dart';

void main() {
  testWidgets('renders the nui_flutter showcase', (tester) async {
    await tester.pumpWidget(const NuiFlutterExampleApp());

    expect(find.text('nui_flutter'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);

    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Inputs'), findsOneWidget);
  });
}
