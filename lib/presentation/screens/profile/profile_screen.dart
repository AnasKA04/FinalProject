import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart';
import '../../../core/theme/app_colors.dart';

import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.isAnonymous,
    required this.role,
    this.displayName,
  });

  final bool isAnonymous;
  final UserRole? role;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    final name = isAnonymous ? 'Anonymous' : (displayName ?? 'User');
    final roleText = role == UserRole.admin
        ? 'Admin'
        : (role == UserRole.therapist ? 'Therapist' : 'Patient');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _headerCard(name: name, roleText: roleText),
          const SizedBox(height: 14),

          _sectionTitle('Account'),
          _card(
            children: [
              _navTile(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Appearance, privacy, notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              _navTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                subtitle: 'Control your data and visibility ',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy ')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          _sectionTitle('Support'),
          _card(
            children: [
              _navTile(
                context,
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Get help using the app ',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & FAQ ')),
                  );
                },
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              _navTile(
                context,
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App information',
                onTap: () => _showAbout(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _card(
            children: [
              _dangerTile(
                context,
                icon: Icons.logout_rounded,
                title: 'Log out',
                subtitle: 'Return to login screen',
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('About PsyCare', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'Prototype app with assessment flow, therapist review, and chat.\n\nVersion: 1.0',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _headerCard({required String name, required String roleText}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primarySoft,
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Role: $roleText', style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        t,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textMuted),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _navTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
    );
  }

  Widget _dangerTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    const danger = Color(0xFFB42318);
    const dangerBg = Color(0xFFFEE4E2);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: dangerBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: danger),
      ),
      title: const Text('Log out', style: TextStyle(fontWeight: FontWeight.w900, color: danger)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
    );
  }
}
