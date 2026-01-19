import 'package:flutter/material.dart';

import '../../../core/booking/booking_store.dart';
import '../../../core/booking/booking_models.dart';

import '../../../core/notifications/notification_store.dart';
import '../../../core/notifications/notification_models.dart';

import 'package:psycare/services/auth_serviece.dart';
import 'package:psycare/services/booking_service.dart';

class TherapistRequestsScreen extends StatefulWidget {
  const TherapistRequestsScreen({super.key, required this.therapistId});

  final String therapistId;

  @override
  State<TherapistRequestsScreen> createState() =>
      _TherapistRequestsScreenState();
}

class _TherapistRequestsScreenState extends State<TherapistRequestsScreen> {
  final bookingStore = BookingStore.instance;

  String _statusLabel(BookingStatus s) => s.name;

  void _accept(Booking b) {
    bookingStore.updateStatus(b.id, BookingStatus.confirmed);

    // ✅ notify patient when therapist accepts
    NotificationStore.instance.push(
      userId: b.patientId,
      type: AppNotificationType.bookingConfirmed,
      title: "Booking confirmed ✅",
      message:
          "Your session is confirmed for ${b.slot.start} with ${b.therapistName}.",
    );

    setState(() {});
  }

  void _reject(Booking b) {
    bookingStore.updateStatus(b.id, BookingStatus.rejected);

    NotificationStore.instance.push(
      userId: b.patientId,
      type: AppNotificationType.bookingRejected,
      title: "Booking rejected",
      message: "Your booking request was rejected by ${b.therapistName}.",
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = bookingStore.bookingsForTherapist(widget.therapistId);

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Requests")),
      body: list.isEmpty
          ? const Center(child: Text("No booking requests yet."))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final b = list[i];

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Type: ${b.type == SessionType.onsite ? "On-site" : "Video"}",
                      ),
                      Text("Time: ${b.slot.start}"),
                      Text("Payment: ${b.paymentMethod.name.toUpperCase()}"),
                      Text("Price: \$${b.price}"),
                      const SizedBox(height: 6),
                      Text(
                        "Status: ${_statusLabel(b.status)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),

                      if (b.status == BookingStatus.pending) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _accept(b),
                                child: const Text("Accept"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _reject(b),
                                child: const Text("Reject"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
