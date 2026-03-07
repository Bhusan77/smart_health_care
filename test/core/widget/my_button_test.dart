import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/core/widget/my_button.dart';

void main() {
  testWidgets("MyButton displays the correct text", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(
            text: "Click Me",
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text("Click Me"), findsOneWidget);
  });

  testWidgets("MyButton calls onPressed when tapped", (WidgetTester tester) async {
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(
            text: "Submit",
            onPressed: () {
              isPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(isPressed, true);
  });
}