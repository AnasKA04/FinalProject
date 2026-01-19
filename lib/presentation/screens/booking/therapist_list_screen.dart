import 'package:flutter/material.dart';

import '../../../core/booking/booking_store.dart';
import '../../../core/booking/booking_models.dart';
import 'therapist_profile_screen.dart';

class TherapistListScreen extends StatelessWidget {
  const TherapistListScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.type,
  });

  final String patientId;
  final String patientName;
  final SessionType type;

  @override
  Widget build(BuildContext context) {
    final list = BookingStore.instance.getTherapists();

    return Scaffold(
      appBar: AppBar(title: const Text("Therapists")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final TherapistProfile t = list[i];

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TherapistProfileScreen(
                    therapistId: t.id, // ✅ fixed
                    patientId: patientId,
                    patientName: patientName,
                    type: type, // ✅ forward the booking type
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Text(t.name.isNotEmpty ? t.name[0] : "T"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${t.locationText} • ⭐ ${t.rating} (${t.ratingCount})",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
