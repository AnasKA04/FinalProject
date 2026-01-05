import 'package:flutter/material.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/assessment/assessment_flow_screen.dart';
import 'home_widgets.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key, required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          children: [
            GreetingCard(
              name: displayName,
              subtitle: "Role: Patient • You’re safe here.",
            ),
            const SizedBox(height: 16),
            const Text("Quick actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            ActionCard(
              title: "Start Assessment",
              subtitle: "Short, adaptive questions",
              icon: Icons.assignment_rounded,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AssessmentFlowScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            ActionCard(
              title: "Mood Check-in",
              subtitle: "Quick daily reflection (UI only)",
              icon: Icons.mood_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mood Check-in (UI only for now)")),
                );
              },
            ),
            const SizedBox(height: 12),

            ActionCard(
              title: "Breathing Exercise",
              subtitle: "60 seconds calm breathing (UI only)",
              icon: Icons.spa_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Breathing (UI only for now)")),
                );
              },
            ),

            const SizedBox(height: 22),
            const Text("Recent activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            const InfoTile(
              title: "No activity yet",
              subtitle: "Once you complete an assessment, you’ll see it here.",
              icon: Icons.history_rounded,
            ),
            const SizedBox(height: 10),
            const InfoTile(
              title: "Tip for today",
              subtitle: "Take 3 slow breaths before you start your day.",
              icon: Icons.lightbulb_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
