import 'package:flutter/material.dart';
// import 'package:smart_health_care/screens/login_screen.dart';
import 'package:smart_health_care/screens/onboard_screenone.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 91, 125, 227),
      body: Center(
        child: Image.asset(
          "assets/images/image.png", 
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
