import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addToCart(Map<String, dynamic> medicine) {
    final medicineId = (medicine["_id"] ?? medicine["id"]).toString();

    final index = state.indexWhere(
      (item) =>
          ((item["medicine"]["_id"] ?? item["medicine"]["id"]).toString()) ==
          medicineId,
    );

    if (index != -1) {
      final updated = [...state];
      updated[index] = {
        ...updated[index],
        "qty": (updated[index]["qty"] as int) + 1,
      };
      state = updated;
    } else {
      state = [
        ...state,
        {
          "medicine": medicine,
          "qty": 1,
        }
      ];
    }
  }

  void increaseQty(String medicineId) {
    state = [
      for (final item in state)
        if (((item["medicine"]["_id"] ?? item["medicine"]["id"]).toString()) ==
            medicineId)
          {
            ...item,
            "qty": (item["qty"] as int) + 1,
          }
        else
          item,
    ];
  }

  void decreaseQty(String medicineId) {
    final updated = <Map<String, dynamic>>[];

    for (final item in state) {
      final id =
          (item["medicine"]["_id"] ?? item["medicine"]["id"]).toString();
      if (id == medicineId) {
        final qty = item["qty"] as int;
        if (qty > 1) {
          updated.add({
            ...item,
            "qty": qty - 1,
          });
        }
      } else {
        updated.add(item);
      }
    }

    state = updated;
  }

  void removeItem(String medicineId) {
    state = state.where((item) {
      final id =
          (item["medicine"]["_id"] ?? item["medicine"]["id"]).toString();
      return id != medicineId;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double totalPrice() {
    double total = 0;
    for (final item in state) {
      final medicine = item["medicine"] as Map<String, dynamic>;
      final price = (medicine["price"] ?? 0).toDouble();
      final qty = item["qty"] as int;
      total += price * qty;
    }
    return total;
  }
}