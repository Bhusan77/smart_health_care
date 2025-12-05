import 'package:flutter/material.dart';
import 'package:smart_health_care/screens/login_screen.dart';
import 'package:smart_health_care/widget/my_button.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  void _goToLogin(BuildContext context) {
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
                  'assets/images/appointment.jpg',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              const Text(
                'Book Appointment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 249, 250, 250),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Book doctor appointments\nin just few seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 254, 254)),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(false),
                  const SizedBox(width: 6),
                  _buildDot(false),
                  const SizedBox(width: 6),
                  _buildDot(true),
                ],
              ),

              const Spacer(),

              MyButton(
                onPressed: () => _goToLogin(context),
                text: 'Get Started',
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
        color: isActive ? const Color(0xFF3E8B3A) : const Color.fromARGB(255, 248, 246, 246),
        shape: BoxShape.circle,
      ),
    );
  }
}
