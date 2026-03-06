import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';

class OrderApi {
  final ApiClient api;
  OrderApi(this.api);

  Future<void> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
  }) async {
    final res = await api.post(
      ApiEndpoints.orders,
      data: {
        "items": items,
        "deliveryAddress": deliveryAddress,
      },
    );

    print("CREATE ORDER RESPONSE: ${res.data}");
  }

  Future<List<dynamic>> myOrders() async {
    final res = await api.get(ApiEndpoints.myOrders);
    final body = res.data;

    print("MY ORDERS RESPONSE: $body");

    if (body is Map && body["orders"] is List) {
      return List<dynamic>.from(body["orders"]);
    }

    if (body is Map && body["data"] is List) {
      return List<dynamic>.from(body["data"]);
    }

    if (body is List) {
      return body;
    }

    return [];
  }
}