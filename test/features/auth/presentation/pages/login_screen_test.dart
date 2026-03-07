import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/auth/presentation/pages/login_screen.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';
import 'package:smart_health_care/features/auth/presentation/view_models/auth_viewmodel.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    Widget createWidgetUnderTest() {
      return ProviderScope(
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      );
    }
    testWidgets('should display email and password fields with proper hints',
        (tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should show validation errors when fields are empty',
        (tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act - tap login button without entering data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // assert
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should toggle password visibility when icon is tapped',
        (tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password field
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(passwordField, findsOneWidget);

      // Initially password should be obscured (visibility_off icon)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // act - tap the visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // assert - password should now be visible (visibility icon)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // act - tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // assert - password should be obscured again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should accept text input in email and password fields',
        (tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act - enter email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // act - enter password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.pump();

      // assert - verify the text was entered
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}