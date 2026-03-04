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
      appBar: AppBar(title: const Text("Doctor Detail")),
      body: doctorAsync.when(
        data: (d) {
          final name = (d["name"] ?? "").toString();

          // ✅ DB/backend uses "specialization"
          final specialization = (d["specialization"] ?? "").toString();

          final fee = (d["fee"] ?? 0).toString();
          final phone = d["phone"]?.toString();
          final clinicAddress = d["clinicAddress"]?.toString();
          final bio = d["bio"]?.toString();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(specialization),
                const SizedBox(height: 6),
                Text("Fee: $fee"),
                const SizedBox(height: 12),
                if (clinicAddress != null && clinicAddress.isNotEmpty)
                  Text("Clinic: $clinicAddress"),
                if (phone != null && phone.isNotEmpty) Text("Phone: $phone"),
                const SizedBox(height: 12),
                if (bio != null && bio.isNotEmpty) Text(bio),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateAppointmentPage(doctorId: doctorId),
                      ),
                    ),
                    child: const Text("Book Appointment"),
                  ),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}