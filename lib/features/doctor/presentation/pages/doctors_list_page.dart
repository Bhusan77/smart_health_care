import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/doctor_provider.dart';
import 'doctor_detail_page.dart';

class DoctorsListPage extends ConsumerWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Doctors")),
      body: doctorsAsync.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text("No doctors found"));

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(doctorsProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final d = list[i] as Map<String, dynamic>;
                final id = (d["_id"] ?? d["id"]).toString();
                final name = (d["name"] ?? "").toString();
                final specialization = (d["specialization"] ?? "").toString();
                final fee = (d["fee"] ?? 0).toString();

                return ListTile(
                  title: Text(name),
                  subtitle: Text("$specialization • Fee: $fee"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DoctorDetailPage(doctorId: id)),
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