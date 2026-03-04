import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';

class DoctorApi {
  final ApiClient api;
  DoctorApi(this.api);

  Future<List<dynamic>> getDoctors({String? q, String? specialization}) async {
    final res = await api.get(
      ApiEndpoints.doctors,
      queryParameters: {
        if (q != null && q.trim().isNotEmpty) "q": q.trim(),
        if (specialization != null && specialization.trim().isNotEmpty)
          "specialization": specialization.trim(),
      },
    );

    final body = res.data;

    // ✅ YOUR backend returns { success: true, doctors: [...] }
    if (body is Map && body["doctors"] is List) {
      return body["doctors"] as List;
    }

    // fallback support (in case you change backend later)
    if (body is List) return body;
    if (body is Map && body["data"] is List) return body["data"] as List;

    return [];
  }

  Future<Map<String, dynamic>> getDoctorById(String id) async {
    final res = await api.get("${ApiEndpoints.doctors}/$id");
    final body = res.data;

    // ✅ YOUR backend returns { success: true, doctor: {...} }
    if (body is Map && body["doctor"] is Map) {
      return Map<String, dynamic>.from(body["doctor"]);
    }

    // fallback support
    if (body is Map && body["data"] is Map) {
      return Map<String, dynamic>.from(body["data"]);
    }

    return Map<String, dynamic>.from(body);
  }
}