// Basic smoke test for inSwing app.
//
// This test verifies the app can launch without errors.

import 'package:flutter_test/flutter_test.dart';

import 'package:inswing/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InSwingApp());

    // Verify the app renders without crashing.
    expect(find.byType(InSwingApp), findsOneWidget);
  });
}
