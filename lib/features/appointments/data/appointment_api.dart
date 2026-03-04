import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';

class AppointmentApi {
  final ApiClient api;
  AppointmentApi(this.api);

  Future<Map<String, dynamic>> createAppointment({
    required String doctorId,
    required String date, // YYYY-MM-DD
    required String time, // HH:mm
    String? reason,
  }) async {
    final res = await api.post(
      ApiEndpoints.appointments,
      data: {
        "doctor": doctorId,
        "date": date,
        "time": time,
        if (reason != null && reason.trim().isNotEmpty) "reason": reason.trim(),
      },
    );

    final body = res.data;

    // ✅ common backend shapes
    if (body is Map && body["appointment"] is Map) {
      return Map<String, dynamic>.from(body["appointment"]);
    }
    if (body is Map && body["data"] is Map) {
      return Map<String, dynamic>.from(body["data"]);
    }

    return Map<String, dynamic>.from(body as Map);
  }

  Future<List<dynamic>> myAppointments() async {
    final res = await api.get("${ApiEndpoints.appointments}/me");
    final body = res.data;

    // ✅ DEBUG (keep for 1 test run)
    print("MY APPOINTMENTS RESPONSE: $body");

    // ✅ Most likely (same style as doctors)
    if (body is Map && body["appointments"] is List) {
      return body["appointments"] as List;
    }

    // ✅ Other common formats
    if (body is List) return body;
    if (body is Map && body["data"] is List) return body["data"] as List;

    // nested possibility: { data: { appointments: [] } }
    if (body is Map && body["data"] is Map && body["data"]["appointments"] is List) {
      return body["data"]["appointments"] as List;
    }

    return [];
  }

  Future<void> cancelAppointment(String id) async {
    await api.patch("${ApiEndpoints.appointments}/$id/cancel");
  }
}