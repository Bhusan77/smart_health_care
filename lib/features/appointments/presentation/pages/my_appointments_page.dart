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
      appBar: AppBar(title: const Text("My Appointments")),
      body: apptsAsync.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text("No appointments yet"));

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myAppointmentsProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final a = list[i] as Map<String, dynamic>;
                final id = (a["_id"] ?? a["id"]).toString();
                final date = (a["date"] ?? "").toString();
                final time = (a["time"] ?? "").toString();
                final status = (a["status"] ?? "PENDING").toString();

                final isCancelled = status.toUpperCase() == "CANCELLED";

                return ListTile(
                  title: Text("$date • $time"),
                  subtitle: Text("Status: $status"),
                  trailing: isCancelled
                      ? const Text("Cancelled")
                      : TextButton(
                          onPressed: action is AsyncLoading
                              ? null
                              : () => ref
                                  .read(appointmentActionProvider.notifier)
                                  .cancel(id),
                          child: const Text("Cancel"),
                        ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}