import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/settings/app_settings_store.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/assessment/assessment_screen.dart';
import '../../../core/assessment/assessment_flow_screen.dart';

import '../therapist/therapist_inbox_screen.dart';
import '../auth/login_screen.dart';

// Chat imports (must exist in your project)
import '../../../core/chat/store.dart';
import '../chat/chat_list_screen.dart';

import '../settings/settings_screen.dart';


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

  void _openChat() {
    final store = ChatStore.instance;

    // Decide who is "current" and who is "other" based on role
    final bool isTherapist = widget.role == UserRole.therapist;
    final bool isPatient = widget.role == UserRole.patient || widget.isAnonymous;

    if (!isTherapist && !isPatient) {
      // Fallback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Role not set for chat.")),
      );
      return;
    }

    final currentUserId = isTherapist ? store.demoTherapistId : store.demoPatientId;
    final currentUserName = isTherapist ? "Therapist" : (widget.displayName ?? "You");
    final otherUserId = isTherapist ? store.demoPatientId : store.demoTherapistId;
    final otherUserName = isTherapist ? "Patient" : "Therapist";

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatListScreen(
          currentUserId: currentUserId,
          currentUserName: currentUserName,
          otherUserId: otherUserId,
          otherUserName: otherUserName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.isAnonymous ? "Friend" : (widget.displayName ?? "User");
    final roleLabel = widget.role?.label;

    final bool isTherapist = widget.role == UserRole.therapist;
    final bool isPatientOrAnon = widget.role == UserRole.patient || widget.isAnonymous;

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
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {
              // TODO: notifications screen later
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],

      ),
      body: AppBackground(
        child: SafeArea(
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

                  // PATIENT / ANONYMOUS
                  if (isPatientOrAnon) ...[
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
                    const SizedBox(height: 12),

                    _ActionCard(
                      title: "Chat",
                      subtitle: "Chat with your therapist",
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: _openChat,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // THERAPIST
                  if (isTherapist) ...[
                    _ActionCard(
                      title: "Chat",
                      subtitle: "Chat with patients",
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: _openChat,
                    ),
                    const SizedBox(height: 12),

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
                    const SizedBox(height: 12),
                  ],

                  // COMMON (both roles)
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
      ),
    );
  }
}

extension on _HomeScreenState {
  void _openAppearanceSheet() {
    final settings = AppSettingsStore.instance;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;

        return Padding(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            bottom: 22 + MediaQuery.of(ctx).viewInsets.bottom,
            top: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appearance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),

              ValueListenableBuilder<ThemeMode>(
                valueListenable: settings.themeMode,
                builder: (_, mode, __) {
                  return Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        groupValue: mode,
                        onChanged: (v) => settings.setThemeMode(v ?? ThemeMode.light),
                        title: const Text('Light'),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        groupValue: mode,
                        onChanged: (v) => settings.setThemeMode(v ?? ThemeMode.dark),
                        title: const Text('Dark'),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        groupValue: mode,
                        onChanged: (v) => settings.setThemeMode(v ?? ThemeMode.system),
                        title: const Text('System'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),

              const Text(
                'Accent color',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              ValueListenableBuilder<Color>(
                valueListenable: settings.seedColor,
                builder: (_, seed, __) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _ColorChip(
                        label: 'Blue',
                        color: const Color(0xFF2F80ED),
                        isSelected: seed.value == const Color(0xFF2F80ED).value,
                        onTap: () => settings.setSeedColor(const Color(0xFF2F80ED)),
                      ),
                      _ColorChip(
                        label: 'Teal',
                        color: const Color(0xFF2BB3A3),
                        isSelected: seed.value == const Color(0xFF2BB3A3).value,
                        onTap: () => settings.setSeedColor(const Color(0xFF2BB3A3)),
                      ),
                      _ColorChip(
                        label: 'Indigo',
                        color: const Color(0xFF4F46E5),
                        isSelected: seed.value == const Color(0xFF4F46E5).value,
                        onTap: () => settings.setSeedColor(const Color(0xFF4F46E5)),
                      ),
                      _ColorChip(
                        label: 'Rose',
                        color: const Color(0xFFE11D48),
                        isSelected: seed.value == const Color(0xFFE11D48).value,
                        onTap: () => settings.setSeedColor(const Color(0xFFE11D48)),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    settings.setThemeMode(ThemeMode.light);
                    settings.setSeedColor(AppColors.primary);
                    Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset to default'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.primary,
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant),
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
              color: cs.primaryContainer.withOpacity(0.55),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Icon(Icons.favorite_rounded, color: cs.primary),
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
                  style: TextStyle(color: cs.onSurfaceVariant, height: 1.35),
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
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Icon(icon, color: cs.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant, height: 1.3)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
