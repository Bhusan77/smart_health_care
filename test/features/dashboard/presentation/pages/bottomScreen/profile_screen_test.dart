import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/auth/presentation/pages/login_screen.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/profile_screen.dart';



void main() {
  group('ProfileScreen Widget Tests', () {
    testWidgets('shows profile screen UI correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      expect(find.text('Edit Profile'), findsNWidgets(2));
      expect(find.text('User Name'), findsOneWidget);
      expect(find.text('example@gmail.com'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('logout navigates to LoginScreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}