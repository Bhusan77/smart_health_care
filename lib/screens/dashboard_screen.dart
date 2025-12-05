import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

            
              const Text(
                "Pharmacy Dashboard",
                style: TextStyle(
                
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "In Sprint 2",
                style: TextStyle(color: Color.fromARGB(255, 21, 20, 20)),
              ),

              const SizedBox(height: 40),

              

              
              

              
            ],
          ),
        ),
      ),
    );
  }
}

  
      
      
