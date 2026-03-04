import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:smart_health_care/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:smart_health_care/features/doctor/presentation/pages/doctors_list_page.dart';
import 'package:smart_health_care/features/doctor/presentation/providers/doctor_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hello 👋\nWelcome back',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 12),
                      Icon(Icons.search),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  CategoryCard(
                    icon: Icons.check_circle,
                    title: 'My Appointments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyAppointmentsPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const CategoryCard(
                    icon: Icons.local_pharmacy,
                    title: 'Pharmacy',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Doctors header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our doctors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DoctorsListPage()),
                      );
                    },
                    child: const Text('View All', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Doctors list from API
              Expanded(
                child: doctorsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(child: Text("No doctors found"));
                    }

                    return RefreshIndicator(
                      onRefresh: () async => ref.refresh(doctorsProvider),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final d = list[i] as Map<String, dynamic>;

                          final id = (d["_id"] ?? d["id"]).toString();
                          final name = (d["name"] ?? "").toString();

                          // ✅ Your DB uses specialization (with z)
                          final specialization =
                              (d["specialization"] ?? d["specialization"] ?? "").toString();

                          final fee = (d["fee"] ?? 0).toString();

                          // Optional fields
                          final phone = d["phone"]?.toString();
                          final email = d["email"]?.toString();
                          final isActive = d["isActive"] == true;

                          return DoctorCard(
                            name: name,
                            specialization: specialization,
                            fee: fee,
                            phone: phone,
                            email: email,
                            isActive: isActive,
                            onBook: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DoctorDetailPage(doctorId: id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue, size: 36),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String fee;
  final String? phone;
  final String? email;
  final bool isActive;
  final VoidCallback onBook;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.fee,
    required this.onBook,
    this.phone,
    this.email,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  specialization,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text("Fee: $fee"),
                if (phone != null && phone!.isNotEmpty) Text("Phone: $phone"),
                if (email != null && email!.isNotEmpty) Text("Email: $email"),
                const SizedBox(height: 6),
                Text(
                  isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onBook,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Book now'),
          ),
        ],
      ),
    );
  }
}