import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/appointments/presentation/providers/appointment_provider.dart';

class AppointmentScreen extends ConsumerWidget {
  const AppointmentScreen({super.key});

  bool _isUpcoming(String? date) {
    if (date == null || date.isEmpty) return false;

    try {
      final appointmentDate = DateTime.parse(date);
      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);
      final compareDate = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
      );

      return !compareDate.isBefore(today);
    } catch (_) {
      return false;
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "No date";

    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (_) {
      return date;
    }
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "No time";

    try {
      final parts = time.split(":");
      if (parts.length < 2) return time;

      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? "PM" : "AM";

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return "$hour:$minute $period";
    } catch (_) {
      return time;
    }
  }

  Color _statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return Colors.green.shade100;
      case "pending":
        return Colors.orange.shade100;
      case "cancelled":
        return Colors.red.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(myAppointmentsProvider);
    final actionState = ref.watch(appointmentActionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text(
          "Upcoming Appointment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: appointmentsAsync.when(
        data: (appointments) {
          final upcomingAppointments = appointments.where((item) {
            final appointment = item as Map<String, dynamic>;
            final date = appointment["date"]?.toString();
            final status = appointment["status"]?.toString().toLowerCase() ?? "";

            return _isUpcoming(date) && status != "cancelled";
          }).toList();

          if (upcomingAppointments.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(myAppointmentsProvider);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text(
                      "No upcoming appointments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myAppointmentsProvider);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: upcomingAppointments.length,
              itemBuilder: (context, index) {
                final appointment =
                    upcomingAppointments[index] as Map<String, dynamic>;

                final id = appointment["_id"]?.toString() ?? "";
                final doctor = appointment["doctor"];

                final doctorName = doctor is Map<String, dynamic>
                    ? (doctor["name"]?.toString() ?? "Unknown Doctor")
                    : "Unknown Doctor";

                final specialty = doctor is Map<String, dynamic>
                    ? (doctor["specialization"]?.toString() ??
                        doctor["specialty"]?.toString() ??
                        "No Specialty")
                    : "No Specialty";

                final hospital = doctor is Map<String, dynamic>
                    ? (doctor["clinicAddress"]?.toString() ??
                        doctor["hospital"]?.toString() ??
                        "Smart Health Care")
                    : "Smart Health Care";

                final date = _formatDate(appointment["date"]?.toString());
                final time = _formatTime(appointment["time"]?.toString());
                final status =
                    appointment["status"]?.toString() ?? "Pending";
                final reason = appointment["reason"]?.toString() ?? "";

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialty,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hospital,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Date: $date",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Time: $time",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            if (reason.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                "Reason: $reason",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _statusBgColor(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: _statusTextColor(status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton.icon(
                                onPressed: actionState is AsyncLoading
                                    ? null
                                    : () async {
                                        await ref
                                            .read(appointmentActionProvider
                                                .notifier)
                                            .cancel(id);

                                        final latest =
                                            ref.read(appointmentActionProvider);

                                        latest.whenOrNull(
                                          error: (e, _) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text("Error: $e"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          data: (_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Appointment cancelled",
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: actionState is AsyncLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.cancel, size: 18),
                                label: Text(
                                  actionState is AsyncLoading
                                      ? "Cancelling..."
                                      : "Cancel",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Failed to load appointments\n$error",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}