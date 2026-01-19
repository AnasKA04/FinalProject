import 'package:flutter/material.dart';
import 'package:psycare/services/auth_serviece.dart';
import 'package:psycare/services/booking_service.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Success")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.check_circle_rounded, size: 70),
            const SizedBox(height: 14),
            const Text(
              "Booking requested ✅",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              "Your booking request was sent to the therapist.\nBooking ID: $bookingId",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                icon: const Icon(Icons.home_rounded),
                label: const Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
