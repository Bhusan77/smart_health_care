import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import '../../data/doctor_api.dart';

final doctorApiProvider = Provider<DoctorApi>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return DoctorApi(apiClient);
});

final doctorsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(doctorApiProvider);
  return api.getDoctors();
});

final doctorByIdProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final api = ref.read(doctorApiProvider);
  return api.getDoctorById(id);
});