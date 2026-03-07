import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/pharmacy_provider.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "DELIVERED":
        return Colors.green;
      case "CONFIRMED":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      case "DISPATCHED":
        return Colors.deepPurple;
      case "PENDING":
      default:
        return Colors.orange;
    }
  }

  Color _paymentColor(String status) {
    switch (status.toUpperCase()) {
      case "SUCCESS":
        return Colors.green;
      case "FAILED":
        return Colors.red;
      case "PENDING":
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No orders yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await ref.refresh(myOrdersProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4DA6FF),
                        Color(0xFF7EC8FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.medical_services,
                          color: Color(0xFF4DA6FF),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Track your medicine orders easily",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(list.length, (i) {
                  final order = Map<String, dynamic>.from(list[i]);

                  final id = (order["_id"] ?? "").toString();
                  final status = (order["status"] ?? "PENDING").toString();
                  final paymentStatus =
                      (order["paymentStatus"] ?? "PENDING").toString();
                  final paymentMethod =
                      (order["paymentMethod"] ?? "ESEWA").toString();
                  final total = (order["total"] ?? 0).toString();
                  final address = (order["deliveryAddress"] ?? "").toString();

                  final itemsRaw = (order["items"] ?? []) as List;
                  final items = itemsRaw
                      .map((e) => Map<String, dynamic>.from(e))
                      .toList();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F2FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_pharmacy,
                            color: Color(0xFF4DA6FF),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order #${id.substring(0, id.length > 8 ? 8 : id.length)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Total: Rs $total",
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (address.isNotEmpty)
                                Text(
                                  address,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(status)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Order: $status",
                                      style: TextStyle(
                                        color: _statusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _paymentColor(paymentStatus)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Payment: $paymentStatus",
                                      style: TextStyle(
                                        color: _paymentColor(paymentStatus),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Method: $paymentMethod",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (items.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                const Text(
                                  "Items",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...items.map((item) {
                                  final qty = item["qty"] ?? 0;
                                  final price = item["priceAtPurchase"] ?? 0;

                                  String medName = "Medicine";
                                  final medicine = item["medicine"];

                                  if (medicine is Map<String, dynamic>) {
                                    medName =
                                        (medicine["name"] ?? "Medicine")
                                            .toString();
                                  } else {
                                    medName = medicine.toString();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      "- $medName x$qty (Rs. $price)",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}