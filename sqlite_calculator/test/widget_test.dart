import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqlite_calc/main.dart';

void main() {
  testWidgets('Calculator displays initial value', (WidgetTester tester) async {
    // Build calculator app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify that the initial value is "0".
    expect(find.text('0'), findsOneWidget);

    // Tap button "1" and trigger a frame.
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify that value updates to "1".
    expect(find.text('1'), findsWidgets); // One from button, one from display

    // Tap button "+"
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap button "1" again
    await tester.tap(find.text('1'));
    await tester.pump();

    // Tap "=" button to evaluate
    await tester.tap(find.text('='));
    await tester.pump();

    // Now output should be "2"
    expect(find.text('2.0'), findsOneWidget);

    // Tap "CLEAR" button and check reset
    await tester.tap(find.text('CLEAR'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
