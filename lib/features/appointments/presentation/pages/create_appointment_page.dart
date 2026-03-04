import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/appointment_provider.dart';

class CreateAppointmentPage extends ConsumerStatefulWidget {
  final String doctorId;
  const CreateAppointmentPage({super.key, required this.doctorId});

  @override
  ConsumerState<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends ConsumerState<CreateAppointmentPage> {
  final reasonCtrl = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    reasonCtrl.dispose();
    super.dispose();
  }

  String _dateToYmd(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _timeToHm(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final action = ref.watch(appointmentActionProvider);

    ref.listen(appointmentActionProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e"))),
        data: (_) {
          if (prev is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Appointment created ✅")),
            );
            Navigator.pop(context);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(selectedDate == null ? "Select date" : _dateToYmd(selectedDate!)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 90)),
                  initialDate: now,
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            ListTile(
              title: Text(selectedTime == null ? "Select time" : _timeToHm(selectedTime!)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
            ),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(
                labelText: "Reason (optional)",
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: action is AsyncLoading
                    ? null
                    : () {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pick date and time")),
                          );
                          return;
                        }

                        ref.read(appointmentActionProvider.notifier).create(
                              doctorId: widget.doctorId,
                              date: _dateToYmd(selectedDate!),
                              time: _timeToHm(selectedTime!),
                              reason: reasonCtrl.text,
                            );
                      },
                child: action is AsyncLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}