import 'package:flutter/material.dart';
import '../../../core/booking/booking_store.dart';
import '../../../core/booking/booking_models.dart';
import 'booking_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.therapistId,
    required this.patientId,
    required this.patientName,
    required this.type,
    required this.slot,
  });

  final String therapistId;
  final String patientId;
  final String patientName;
  final SessionType type;
  final BookingSlot slot;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _method;

  List<PaymentMethod> get _options {
    // Your rule:
    // onsite => VISA, CliQ, Cash
    // video => VISA, CliQ
    if (widget.type == SessionType.onsite) {
      return [PaymentMethod.visa, PaymentMethod.cliq, PaymentMethod.cash];
    }
    return [PaymentMethod.visa, PaymentMethod.cliq];
  }

  String _label(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.visa:
        return "VISA";
      case PaymentMethod.cliq:
        return "CliQ";
      case PaymentMethod.cash:
        return "Cash";
    }
  }

  void _payNow() {
    if (_method == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choose a payment method.")),
      );
      return;
    }

    // Payment success (MVP)
    final booking = BookingStore.instance.createBooking(
      patientId: widget.patientId,
      patientName: widget.patientName,
      therapistId: widget.therapistId,
      type: widget.type,
      slot: widget.slot,
      paymentMethod: _method!,
    );

    // ✅ Patient gets local success message (therapist notification already sent by store)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessScreen(bookingId: booking.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeText = widget.type == SessionType.onsite ? "On-site" : "Video call";

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("Session: $typeText\nTime: ${widget.slot.start}"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose payment method",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ..._options.map((m) {
              return RadioListTile<PaymentMethod>(
                value: m,
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v),
                title: Text(_label(m)),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _payNow,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text("Pay & Request booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
