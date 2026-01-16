import 'package:flutter/material.dart';
import '../../../core/booking/booking_store.dart';
import '../../../core/booking/booking_models.dart';
import 'payment_screen.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import 'package:psycare/serviece/booking_serviece.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingSlotsScreen extends StatelessWidget {
  const BookingSlotsScreen({
    super.key,
    required this.therapistId,
    required this.patientId,
    required this.patientName,
    required this.type,
  });

  final String therapistId;
  final String patientId;
  final String patientName;
  final SessionType type;
  final u = FirebaseAuth.instance.currentUser;
  final patientId = u?.uid ?? '';
  final patientName = u?.email ?? 'Patient';

  @override
  Widget build(BuildContext context) {
    final slots = BookingStore.instance.getAvailableSlots(therapistId, type);

    return Scaffold(
      appBar: AppBar(title: const Text("Choose date & time")),
      body: slots.isEmpty
          ? const Center(child: Text("No available slots right now."))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: slots.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = slots[i];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TherapistsFirestoreScreen(
                    type: type,               // the session type you already have
                    patientId: patientId,     // current user id
                    patientName: patientName, // current user name
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s.start.toString())),
                  Icon(Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
