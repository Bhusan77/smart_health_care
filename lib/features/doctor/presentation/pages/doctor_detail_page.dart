import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/doctor_provider.dart';
import '../../../appointments/presentation/pages/create_appointment_page.dart';

class DoctorDetailPage extends ConsumerWidget {
  final String doctorId;
  const DoctorDetailPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorByIdProvider(doctorId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F7FA),
        foregroundColor: Colors.black,
        title: const Text(
          "Doctor Detail",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: doctorAsync.when(
        data: (d) {
          final name = (d["name"] ?? "").toString();
          final specialization = (d["specialization"] ?? "").toString();
          final fee = (d["fee"] ?? 0).toString();
          final phone = d["phone"]?.toString() ?? "";
          final clinicAddress = d["clinicAddress"]?.toString() ?? "";
          final bio = d["bio"]?.toString() ?? "";
          final email = d["email"]?.toString() ?? "";
          final isActive = d["isActive"] == true;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top profile card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF6FB1FC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.18),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 42,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                specialization.isEmpty
                                    ? "Specialist"
                                    : specialization,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withOpacity(0.18)
                                    : Colors.red.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isActive ? "Available" : "Unavailable",
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Stats cards
                      Row(
                        children: [
                          Expanded(
                            child: _InfoStatCard(
                              icon: Icons.money_rounded,
                              title: "Consultation Fee",
                              value: fee,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoStatCard(
                              icon: Icons.local_hospital,
                              title: "Department",
                              value: specialization.isEmpty
                                  ? "General"
                                  : specialization,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (phone.isNotEmpty)
                        _DetailSectionCard(
                          title: "Phone",
                          icon: Icons.phone,
                          child: Text(
                            phone,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),

                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _DetailSectionCard(
                          title: "Email",
                          icon: Icons.email_outlined,
                          child: Text(
                            email,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],

                      if (clinicAddress.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _DetailSectionCard(
                          title: "Clinic Address",
                          icon: Icons.location_on_outlined,
                          child: Text(
                            clinicAddress,
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      ],

                      if (bio.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _DetailSectionCard(
                          title: "About Doctor",
                          icon: Icons.info_outline,
                          child: Text(
                            bio,
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom button
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateAppointmentPage(doctorId: doctorId),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month),
                    label: const Text(
                      "Book Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Error: $e",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoStatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailSectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4A90E2)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}