import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/assessment/assessment_screen.dart';
import '../../../core/assessment/assessment_flow_screen.dart';
import '../therapist/therapist_inbox_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isAnonymous,
    this.role,
    this.displayName,
  });

  final bool isAnonymous;
  final UserRole? role;
  final String? displayName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _goAssessment() {
    Navigator.of(context).push(
      AppTransitions.fadeSlide(const AssessmentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.isAnonymous ? "Friend" : (widget.displayName ?? "User");
    final roleLabel = widget.role?.label;

    return Scaffold(
      appBar: AppBar(
        title: const Text("PsyCare"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              children: [
                _GreetingCard(
                  name: name,
                  subtitle: widget.isAnonymous
                      ? "You’re browsing anonymously — calm and private."
                      : "Role: ${roleLabel ?? "User"} • You’re safe here.",
                ),
                const SizedBox(height: 16),

                const Text(
                  "Quick actions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                if (widget.role == UserRole.patient || widget.isAnonymous) ...[
                  _ActionCard(
                    title: "Start Assessment",
                    subtitle: "Short, adaptive questions",
                    icon: Icons.assignment_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AssessmentFlowScreen()),
                      );
                    },
                  ),
                ] else if (widget.role == UserRole.therapist) ...[
                  _ActionCard(
                    title: "Patient Submissions",
                    subtitle: "Review assessments and follow up safely",
                    icon: Icons.inbox_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TherapistInboxScreen()),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 12),
                _ActionCard(
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
                _ActionCard(
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
                const Text(
                  "Recent activity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _InfoTile(
                  title: "No activity yet",
                  subtitle: "Once you complete an assessment, you’ll see it here.",
                  icon: Icons.history_rounded,
                ),
                const SizedBox(height: 10),
                _InfoTile(
                  title: "Tip for today",
                  subtitle: "Take 3 slow breaths before you start your day.",
                  icon: Icons.lightbulb_outline_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.name, required this.subtitle});
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withOpacity(0.45),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.favorite_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $name 👋",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textMuted, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withOpacity(0.45),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: AppColors.textMuted, height: 1.3)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
