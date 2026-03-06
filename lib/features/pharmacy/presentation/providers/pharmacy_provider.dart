import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/features/pharmacy/data/pharmacy_api.dart';

final pharmacyApiProvider = Provider<PharmacyApi>((ref) {
  final api = ref.read(apiClientProvider);
  return PharmacyApi(api);
});

final medicinesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(pharmacyApiProvider);
  return api.getMedicines();
});