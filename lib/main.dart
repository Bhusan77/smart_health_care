import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_health_care/app/app.dart';
import 'package:smart_health_care/core/services/hive/hive_service.dart';
import 'package:smart_health_care/core/services/storage/user_session_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  final sharedPreferences = await SharedPreferences.getInstance();
   runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );

}