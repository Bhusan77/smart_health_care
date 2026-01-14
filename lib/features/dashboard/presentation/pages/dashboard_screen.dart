import 'package:flutter/material.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/home_screen.dart' show HomeScreen;
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/pharmacy_screen.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/profile_screen.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/report_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PharmacyScreen(),
    const ReportScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 THIS LINE FIXES WHITE SCREEN
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_information), label: "Pharmacy"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Reports"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        backgroundColor: Color.fromARGB(255, 118, 178, 238),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}