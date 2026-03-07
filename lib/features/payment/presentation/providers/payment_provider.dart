import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/features/payment/data/data_source/payment_remote_data_source.dart';

final paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return PaymentRemoteDataSource(api);
});