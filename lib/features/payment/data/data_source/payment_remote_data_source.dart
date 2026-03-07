import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';

class PaymentRemoteDataSource {
  final ApiClient api;

  PaymentRemoteDataSource(this.api);

  Future<Map<String, dynamic>> initiateEsewaPayment({
    required String orderId,
  }) async {
    final res = await api.post(
      ApiEndpoints.initiateEsewaPayment,
      data: {
        "orderId": orderId,
      },
    );

    return Map<String, dynamic>.from(res.data);
  }
}