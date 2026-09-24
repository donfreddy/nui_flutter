import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/nui_flutter.dart';

Widget _app(Widget home) {
  return MaterialApp(
    theme: NTheme.lightTheme(colors: NColors.light()),
    home: home,
  );
}

void main() {
  group('NToaster', () {
    testWidgets('stacks concurrent toasts instead of overlapping at the same offset', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _app(
          NToaster(
            max: 3,
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const Scaffold(body: SizedBox.expand());
              },
            ),
          ),
        ),
      );

      NToast.show(capturedContext, title: 'First', duration: const Duration(seconds: 1));
      await tester.pump();
      NToast.show(capturedContext, title: 'Second', duration: const Duration(seconds: 1));
      await tester.pump();
      NToast.show(capturedContext, title: 'Third', duration: const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);

      final positionedFinder = find.byWidgetPredicate((w) => w is AnimatedPositioned);
      final offsets = tester
          .widgetList<AnimatedPositioned>(positionedFinder)
          .map((w) => w.bottom)
          .toSet();
      // The whole point of NToaster: distinct toasts must not share the
      // same offset (the overlap bug being fixed).
      expect(offsets.length, 3, reason: 'each stacked toast should have its own offset');

      // Let the 1s auto-dismiss timers fire and their exit animations
      // finish so no Timer is left pending at test teardown.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsNothing);
      expect(find.text('Third'), findsNothing);
    });

    testWidgets('evicts the oldest toast once max is exceeded', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _app(
          NToaster(
            max: 2,
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const Scaffold(body: SizedBox.expand());
              },
            ),
          ),
        ),
      );

      NToast.show(capturedContext, title: 'A', duration: Duration.zero);
      await tester.pump();
      NToast.show(capturedContext, title: 'B', duration: Duration.zero);
      await tester.pump();
      NToast.show(capturedContext, title: 'C', duration: Duration.zero);
      // Eviction plays an exit animation (300ms slide + 250ms position).
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('A'), findsNothing, reason: 'oldest toast should have been evicted');
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('dismiss(id) closes a specific managed toast', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _app(
          NToaster(
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const Scaffold(body: SizedBox.expand());
              },
            ),
          ),
        ),
      );

      final id = NToast.show(capturedContext, title: 'Dismiss me', duration: Duration.zero);
      await tester.pump();
      expect(find.text('Dismiss me'), findsOneWidget);

      NToaster.of(capturedContext).dismiss(id);
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Dismiss me'), findsNothing);
    });

    testWidgets('NToast.show falls back to a standalone overlay without an NToaster ancestor', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox.expand());
            },
          ),
        ),
      );

      NToast.show(capturedContext, title: 'No toaster', duration: const Duration(seconds: 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('No toaster'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('No toaster'), findsNothing);
    });
  });
}
