import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';

class PharmacyApi {
  final ApiClient api;
  PharmacyApi(this.api);

  Future<List<dynamic>> getMedicines() async {
    final res = await api.get(ApiEndpoints.medicines);
    final body = res.data;

    if (body is Map && body["medicines"] is List) {
      return body["medicines"];
    }

    return [];
  }

  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
  }) async {
    final res = await api.post(
      ApiEndpoints.createPharmacyOrder,
      data: {
        "items": items,
        "deliveryAddress": deliveryAddress,
      },
    );

    return Map<String, dynamic>.from(res.data);
  }

  Future<List<dynamic>> getMyOrders() async {
    final res = await api.get(ApiEndpoints.myPharmacyOrders);
    final body = res.data;

    if (body is Map && body["orders"] is List) {
      return body["orders"];
    }

    return [];
  }
}