import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/appointment_provider.dart';

class MyAppointmentsPage extends ConsumerWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apptsAsync = ref.watch(myAppointmentsProvider);
    final action = ref.watch(appointmentActionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "My Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: apptsAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No appointments yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myAppointmentsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final a = list[i] as Map<String, dynamic>;

                final id = (a["_id"] ?? a["id"]).toString();
                final date = (a["date"] ?? "").toString();
                final time = (a["time"] ?? "").toString();
                final status = (a["status"] ?? "PENDING").toString();

                final doctor = a["doctor"];
                final doctorName =
                    doctor is Map ? (doctor["name"] ?? "Doctor") : "Doctor";

                final isCancelled =
                    status.toUpperCase() == "CANCELLED";

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Doctor name
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              doctorName.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          /// Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isCancelled
                                  ? Colors.red.withOpacity(0.15)
                                  : Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCancelled
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(date),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Time
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(time),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// Cancel button
                      if (!isCancelled)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text("Cancel"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: action is AsyncLoading
                                ? null
                                : () => ref
                                    .read(
                                        appointmentActionProvider.notifier)
                                    .cancel(id),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}