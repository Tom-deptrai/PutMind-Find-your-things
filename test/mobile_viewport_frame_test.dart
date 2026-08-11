import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/widgets/mobile_viewport_frame.dart';

void main() {
  testWidgets('MobileViewportFrame passes through on narrow layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(390, 844)),
          child: MobileViewportFrame(child: Text('phone')),
        ),
      ),
    );

    expect(find.text('phone'), findsOneWidget);
    // On non-web test binding, frame is a no-op pass-through.
    expect(find.byType(MobileViewportFrame), findsOneWidget);
  });
}
