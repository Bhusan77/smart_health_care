import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/features/orders/data/order_api.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/cart_provider.dart';

final orderApiProvider = Provider<OrderApi>((ref) {
  final api = ref.read(apiClientProvider);
  return OrderApi(api);
});

final myOrdersProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(orderApiProvider);
  return api.myOrders();
});

final orderActionProvider =
    StateNotifierProvider<OrderActionNotifier, AsyncValue<void>>((ref) {
  return OrderActionNotifier(ref);
});

class OrderActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  OrderActionNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> placeOrder({
    required String deliveryAddress,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cart = ref.read(cartProvider);

      final items = cart.map((item) {
        final medicine = item["medicine"] as Map<String, dynamic>;
        return {
          "medicine": (medicine["_id"] ?? medicine["id"]).toString(),
          "qty": item["qty"],
        };
      }).toList();

      final api = ref.read(orderApiProvider);
      await api.createOrder(
        items: items,
        deliveryAddress: deliveryAddress,
      );

      ref.read(cartProvider.notifier).clearCart();
      ref.invalidate(myOrdersProvider);
    });
  }
}