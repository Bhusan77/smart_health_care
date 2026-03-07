import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import '../../data/appointment_api.dart';

final appointmentApiProvider = Provider<AppointmentApi>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AppointmentApi(apiClient);
});

final myAppointmentsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(appointmentApiProvider);
  return api.myAppointments();
});

final appointmentActionProvider =
    StateNotifierProvider<AppointmentActionNotifier, AsyncValue<void>>((ref) {
  return AppointmentActionNotifier(ref);
});

class AppointmentActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AppointmentActionNotifier(this.ref) : super(const AsyncData(null));

  Future<void> create({
    required String doctorId,
    required String date,
    required String time,
    String? reason,
  }) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(appointmentApiProvider);
      await api.createAppointment(
        doctorId: doctorId,
        date: date,
        time: time,
        reason: reason,
      );
      ref.invalidate(myAppointmentsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancel(String appointmentId) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(appointmentApiProvider);
      await api.cancelAppointment(appointmentId);
      ref.invalidate(myAppointmentsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}