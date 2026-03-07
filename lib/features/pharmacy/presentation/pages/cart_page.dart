import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/payment/presentation/pages/esewa_payment_page.dart';
import 'package:smart_health_care/features/payment/presentation/providers/payment_provider.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/cart_provider.dart';
import 'package:smart_health_care/features/pharmacy/presentation/providers/pharmacy_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final addressCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrderAndPay() async {
  final cart = ref.read(cartProvider);
  final cartNotifier = ref.read(cartProvider.notifier);

  if (cart.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart is empty")),
    );
    return;
  }

  if (addressCtrl.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter delivery address")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final pharmacyApi = ref.read(pharmacyApiProvider);
    final paymentRemote = ref.read(paymentRemoteDataSourceProvider);

    final items = cart.map((item) {
      final medicine = item["medicine"] as Map<String, dynamic>;
      final medicineId = (medicine["_id"] ?? medicine["id"]).toString();
      final qty = item["qty"] as int;

      return {
        "medicine": medicineId,
        "qty": qty,
      };
    }).toList();

    // 1. Create order
    final orderRes = await pharmacyApi.createOrder(
      items: items,
      deliveryAddress: addressCtrl.text.trim(),
    );

    if (orderRes["success"] != true) {
      throw Exception(orderRes["message"] ?? "Order creation failed");
    }

    final order = Map<String, dynamic>.from(orderRes["order"] ?? {});
    final orderId = (order["_id"] ?? "").toString();

    if (orderId.isEmpty) {
      throw Exception("Order ID not returned from backend");
    }

    // 2. Initiate eSewa payment
    final paymentRes = await paymentRemote.initiateEsewaPayment(
      orderId: orderId,
    );

    debugPrint("Payment response: $paymentRes");

    if (paymentRes["success"] != true) {
      throw Exception(paymentRes["message"] ?? "Payment initiation failed");
    }

    final paymentUrl = (paymentRes["paymentUrl"] ?? "").toString();
    final formData = Map<String, dynamic>.from(paymentRes["formData"] ?? {});

    if (paymentUrl.isEmpty || formData.isEmpty) {
      throw Exception("Invalid payment data from backend");
    }

    if (!mounted) return;

    // 3. Open eSewa payment page
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EsewaPaymentPage(
          paymentUrl: paymentUrl,
          formData: formData,
        ),
      ),
    );

    // always refresh once
    ref.invalidate(myOrdersProvider);

    if (!mounted) return;

    if (result == true) {
      // give backend a moment to verify and update DB
      await Future.delayed(const Duration(seconds: 2));

      final refreshedOrders = await ref.refresh(myOrdersProvider.future);

      Map<String, dynamic>? paidOrder;
      for (final raw in refreshedOrders) {
        final o = Map<String, dynamic>.from(raw);
        if ((o["_id"] ?? "").toString() == orderId) {
          paidOrder = o;
          break;
        }
      }

      final paymentStatus =
          (paidOrder?["paymentStatus"] ?? "PENDING").toString().toUpperCase();
      final orderStatus =
          (paidOrder?["status"] ?? "PENDING").toString().toUpperCase();

      if (paymentStatus == "SUCCESS" || orderStatus == "CONFIRMED") {
        cartNotifier.clearCart();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment successful ✅")),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment callback received, but order not confirmed yet"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed or cancelled")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cart.isEmpty
          ? const _EmptyCartView()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Color(0xFF22C55E),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "${cart.length} item(s) in your cart",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...List.generate(cart.length, (i) {
                          final item = cart[i];
                          final medicine =
                              item["medicine"] as Map<String, dynamic>;
                          final id =
                              (medicine["_id"] ?? medicine["id"]).toString();
                          final name = (medicine["name"] ?? "").toString();
                          final price = (medicine["price"] ?? 0).toDouble();
                          final qty = item["qty"] as int;
                          final total = price * qty;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 58,
                                  width: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFFAF3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.medication_outlined,
                                    color: Color(0xFF22C55E),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Rs ${price.toStringAsFixed(2)} each",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Subtotal: Rs ${total.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          _QtyButton(
                                            icon: Icons.remove,
                                            onTap: () =>
                                                cartNotifier.decreaseQty(id),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              qty.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          _QtyButton(
                                            icon: Icons.add,
                                            onTap: () =>
                                                cartNotifier.increaseQty(id),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () =>
                                                cartNotifier.removeItem(id),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        const Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: addressCtrl,
                            minLines: 3,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "Enter your delivery address...",
                              contentPadding: EdgeInsets.all(16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label: "Items",
                                value: cart.length.toString(),
                              ),
                              const SizedBox(height: 10),
                              _SummaryRow(
                                label: "Total Amount",
                                value:
                                    "Rs ${cartNotifier.totalPrice().toStringAsFixed(2)}",
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: isLoading ? null : _placeOrderAndPay,
                      icon: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.payment),
                      label: Text(
                        isLoading ? "Processing..." : "Place Order & Pay",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 54,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add medicines from the pharmacy to place your order.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFEFFAF3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF22C55E),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 15,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      color: isBold ? Colors.black : Colors.grey[700],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}