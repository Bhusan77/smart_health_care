import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/auth/presentation/pages/signup_screen.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';
import 'package:smart_health_care/features/auth/presentation/view_models/auth_viewmodel.dart';

class FakeAuthViewModel extends AuthViewModel {
  bool registerCalled = false;
  String? usernameValue;
  String? emailValue;
  String? passwordValue;

  @override
  AuthState build() {
    return const AuthState();
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    registerCalled = true;
    usernameValue = username;
    emailValue = email;
    passwordValue = password;

    // do not change state here
    // state = state.copyWith(status: AuthStatus.registered);
  }

  @override
  void resetState() {
    state = const AuthState();
  }
}

void main() {
  late FakeAuthViewModel fakeAuthViewModel;

  Widget createWidget() {
    fakeAuthViewModel = FakeAuthViewModel();

    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => fakeAuthViewModel),
      ],
      child: const MaterialApp(
        home: SignUpScreen(),
      ),
    );
  }

  group('SignUpScreen Widget Tests', () {
    testWidgets('SignUpScreen renders UI elements', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Checkbox toggles correctly', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });
  });
}