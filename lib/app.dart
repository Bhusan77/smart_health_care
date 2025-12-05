import 'package:flutter/material.dart';
// import 'package:smart_health_care/screens/dashboard_screen.dart';
import 'package:smart_health_care/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}