import 'package:flutter/material.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/appointment_screen.dart';

import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/home_screen.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/bottomScreen/profile_screen.dart';
import 'package:smart_health_care/features/orders/presentation/pages/my_order_page.dart';
import 'package:smart_health_care/features/pharmacy/presentation/pages/pharmacy_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PharmacyPage(),
    const AppointmentScreen(),
    const MyOrdersPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: "Pharmacy",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Appointment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 118, 178, 238),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}