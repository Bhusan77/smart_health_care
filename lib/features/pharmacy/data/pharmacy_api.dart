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
}