import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/pharmacy/presentation/pages/pharmacy_page.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/pharmacy_provider.dart';

void main() {
  group('PharmacyPage Widget Tests', () {
    testWidgets('shows loading indicator while medicines are loading',
        (tester) async {
      final completer = Completer<List<dynamic>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicinesProvider.overrideWith((ref) => completer.future),
          ],
          child: const MaterialApp(
            home: PharmacyPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when medicines fail to load',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicinesProvider.overrideWith((ref) async {
              throw Exception("Failed to load medicines");
            }),
          ],
          child: const MaterialApp(
            home: PharmacyPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining("Error:"), findsOneWidget);
      expect(find.textContaining("Failed to load medicines"), findsOneWidget);
    });

    testWidgets('shows no medicines available when list is empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicinesProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(
            home: PharmacyPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("No medicines available"), findsOneWidget);
    });
  });
}