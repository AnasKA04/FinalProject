import 'package:flutter/material.dart';

import '../../../core/booking/booking_models.dart';
import 'booking_slots_screen.dart';

class BookingTypeScreen extends StatelessWidget {
  const BookingTypeScreen({
    super.key,
    required this.therapistId,
    required this.patientId,
    required this.patientName,
  });

  final String therapistId;
  final String patientId;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose session type")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              context,
              title: "On-site session",
              subtitle: "Visit the therapist in person",
              icon: Icons.location_on_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingSlotsScreen(
                      therapistId: therapistId,
                      patientId: patientId,
                      patientName: patientName,
                      type: SessionType.onsite,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _card(
              context,
              title: "Video call",
              subtitle: "Online session by video",
              icon: Icons.videocam_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingSlotsScreen(
                      therapistId: therapistId,
                      patientId: patientId,
                      patientName: patientName,
                      type: SessionType.video,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
  }
}
