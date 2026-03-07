import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/pharmacy_provider.dart';


class PharmacyPage extends ConsumerWidget {
  const PharmacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(medicinesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Olala Medical Hall")),
      body: medicinesAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("No medicines available"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final m = list[i] as Map<String, dynamic>;

              final name = m["name"] ?? "";
              final price = m["price"] ?? 0;
              final stock = m["stock"] ?? 0;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text("Price: Rs $price"),
                  trailing: Text("Stock: $stock"),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}