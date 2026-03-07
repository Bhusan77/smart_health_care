import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/auth/presentation/pages/change_password_screen.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';
import 'package:smart_health_care/features/auth/presentation/view_models/auth_viewmodel.dart';

class FakeAuthViewModel extends AuthViewModel {
  bool changePasswordCalled = false;
  String? capturedOldPassword;
  String? capturedNewPassword;

  @override
  AuthState build() {
    return const AuthState();
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    changePasswordCalled = true;
    capturedOldPassword = oldPassword;
    capturedNewPassword = newPassword;

    state = state.copyWith(status: AuthStatus.passwordChanged);
  }

  @override
  void resetState() {
    state = const AuthState();
  }
}

void main() {
  late FakeAuthViewModel fakeAuthViewModel;

  Widget createWidget() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() {
          fakeAuthViewModel = FakeAuthViewModel();
          return fakeAuthViewModel;
        }),
      ],
      child: const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );
  }

  group('ChangePasswordScreen widget tests', () {
    testWidgets('renders all text fields and button', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Update Password'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Old password is required'), findsOneWidget);
      expect(find.text('New password is required'), findsOneWidget);
      expect(find.text('Confirm password is required'), findsOneWidget);
    });

    testWidgets('shows validation error for short new password', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'old123');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.enterText(find.byType(TextFormField).at(2), '123');

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('shows validation error when passwords do not match', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'old123');
      await tester.enterText(find.byType(TextFormField).at(1), 'new123');
      await tester.enterText(find.byType(TextFormField).at(2), 'wrong123');

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('calls changePassword when form is valid', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextFormField).at(0), 'old123');
      await tester.enterText(find.byType(TextFormField).at(1), 'new123');
      await tester.enterText(find.byType(TextFormField).at(2), 'new123');

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(fakeAuthViewModel.changePasswordCalled, true);
      expect(fakeAuthViewModel.capturedOldPassword, 'old123');
      expect(fakeAuthViewModel.capturedNewPassword, 'new123');
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows loading indicator when status is loading', (tester) async {
      final loadingVm = FakeAuthViewModel();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => loadingVm),
          ],
          child: const MaterialApp(
            home: ChangePasswordScreen(),
          ),
        ),
      );

      loadingVm.state = loadingVm.state.copyWith(status: AuthStatus.loading);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}