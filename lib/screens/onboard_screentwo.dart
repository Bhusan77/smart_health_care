import 'package:flutter/material.dart';
import 'package:smart_health_care/screens/login_screen.dart';
import 'package:smart_health_care/screens/onboard_screenthree.dart';
import 'package:smart_health_care/widget/my_button.dart';




class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  void _goToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Onboarding3(),
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
                  'assets/images/medicine.jpg',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              const Text(
                'Telemedicine',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 248, 250, 251),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Consult professional doctors\nfrom your home.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 7, 7, 7)),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(false),
                  const SizedBox(width: 6),
                  _buildDot(true),
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
                        color: Color.fromARGB(255, 243, 243, 245),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  MyButton(
                    onPressed: () => _goToNext(context),
                    text: 'Next',
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
