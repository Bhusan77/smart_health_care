import 'package:flutter/material.dart';
import 'package:smart_health_care/core/widget/my_button.dart';
import 'package:smart_health_care/features/auth/presentation/pages/login_screen.dart';
import 'package:smart_health_care/features/auth/presentation/pages/onboard_screentwo.dart';




class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  void _goToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Onboarding2(),
      ),
    );
  }

  void _skipToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 107, 233),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const Spacer(),

              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/doctor.jpg',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              const Text(
                'Search Doctors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 248, 250, 251),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Find top doctors near you and\nchoose the best one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 7, 7, 7)),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(true),
                  const SizedBox(width: 6),
                  _buildDot(false),
                  const SizedBox(width: 6),
                  _buildDot(false),
                ],
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _skipToLogin(context),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 244, 245),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  MyButton(
                    onPressed: () => _goToNext(context),
                    text: 'Start here?',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 8 : 6,
      height: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3E8B3A) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
