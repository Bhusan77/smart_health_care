import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/core/widget/my_textformfield.dart';


void main() {
  testWidgets("MyTextFormField shows label and hint text",
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextFormField(
            label: "Email",
            hintText: "Enter your email",
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Enter your email"), findsOneWidget);
  });

  testWidgets("MyTextFormField updates controller when text is entered",
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextFormField(
            label: "Username",
            controller: controller,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), "Bhusan");
    expect(controller.text, "Bhusan");
  });

  testWidgets("MyTextFormField validator shows error message",
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: MyTextFormField(
              label: "Password",
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password required";
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text("Password required"), findsOneWidget);
  });
}