import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';

class AssessmentSubmittedScreen extends StatelessWidget {
  const AssessmentSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submitted"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Thank you.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    SizedBox(height: 10),
                    Text(
                      "Your responses have been sent to your therapist for review.\n\n"
                          "A therapist will contact you to support you safely.",
                      style: TextStyle(color: AppColors.textMuted, height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  "If you feel unsafe right now, please contact local emergency services immediately.",
                  style: TextStyle(color: AppColors.textMuted, height: 1.35),
                ),
              ),
              const Spacer(),
              AppButton(
                label: "Back to Home",
                icon: Icons.home_rounded,
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
