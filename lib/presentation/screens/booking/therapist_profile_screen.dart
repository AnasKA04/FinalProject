import 'package:flutter/material.dart';
import '../../../core/booking/booking_store.dart';
import '../../../core/booking/booking_models.dart';
import '../../../core/chat/store.dart';
import '../chat/chat_list_screen.dart';
import 'booking_type_screen.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import 'package:psycare/serviece/booking_serviece.dart';

class TherapistProfileScreen extends StatelessWidget {
  const TherapistProfileScreen({
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
    final therapist = BookingStore.instance.therapistById(therapistId);

    return Scaffold(
      appBar: AppBar(title: const Text("Therapist Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(context, therapist),
          const SizedBox(height: 14),

          _infoCard(
            context,
            title: "Contact",
            children: [
              _row("Phone", therapist.phoneNumber),
              const SizedBox(height: 6),
              _row("Location", therapist.locationText),
              const SizedBox(height: 6),
              _row("Maps link", therapist.locationUrl),
            ],
          ),

          const SizedBox(height: 12),

          _infoCard(
            context,
            title: "Qualifications",
            children: therapist.qualifications
                .map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text("• $q"),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),

          _infoCard(
            context,
            title: "Prices",
            children: [
              _row("On-site", "\$${therapist.priceOnsite}"),
              const SizedBox(height: 6),
              _row("Video call", "\$${therapist.priceVideo}"),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // MVP chat: uses your existing chat list
                    final store = ChatStore.instance;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatListScreen(
                          currentUserId: patientId,
                          currentUserName: patientName,
                          otherUserId: store.demoTherapistId,
                          otherUserName: "Therapist",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text("Chat"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingTypeScreen(
                          therapistId: therapistId,
                          patientId: patientId,
                          patientName: patientName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: const Text("Book now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, TherapistProfile t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, child: Text(t.name.isNotEmpty ? t.name[0] : "T")),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text("${t.locationText} • ⭐ ${t.rating} (${t.ratingCount})",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String a, String b) {
    return Row(
      children: [
        Expanded(child: Text(a, style: const TextStyle(fontWeight: FontWeight.w800))),
        Expanded(child: Text(b)),
      ],
    );
  }
}
