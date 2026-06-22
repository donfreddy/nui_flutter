import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/nui_flutter.dart';

void main() {
  final palette = NColorPalette.light(
    primary: Colors.blue,
    secondary: Colors.grey,
    success: Colors.green,
    error: Colors.red,
  );

  testWidgets('NToast dragToClose dismisses the overlay', (tester) async {
    final theme = NTheme.lightTheme(palette: palette);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return NButton(
                label: 'Show toast',
                onPressed: () {
                  NToast.show(
                    context,
                    title: 'Drag me',
                    description: 'This toast can be dismissed with a drag.',
                    dragToClose: true,
                    duration: Duration.zero,
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show toast'));
    await tester.pumpAndSettle();

    expect(find.text('Drag me'), findsOneWidget);

    await tester.drag(find.text('Drag me'), const Offset(0, -120));
    await tester.pumpAndSettle();

    expect(find.text('Drag me'), findsNothing);
  });

  testWidgets('NToast dragToClose calls onClose when used directly',
      (tester) async {
    final theme = NTheme.lightTheme(palette: palette);
    var closed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: NToast(
            title: 'Direct toast',
            dragToClose: true,
            onClose: () => closed = true,
          ),
        ),
      ),
    );

    await tester.drag(find.text('Direct toast'), const Offset(0, 120));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
  });

  testWidgets('NToast pauseOnTouch pauses auto dismiss', (tester) async {
    final theme = NTheme.lightTheme(palette: palette);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  NToast.show(
                    context,
                    title: 'Hold me',
                    pauseOnTouch: true,
                    duration: const Duration(seconds: 10),
                  );
                },
                child: const Text('Show pause toast'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show pause toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Hold me')),
    );

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Hold me'), findsOneWidget);

    await gesture.up();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();

    expect(find.text('Hold me'), findsNothing);
  });
}
