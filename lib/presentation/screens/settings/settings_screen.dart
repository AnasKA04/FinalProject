import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import 'package:psycare/serviece/booking_serviece.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local settings (no extra packages needed)
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _sounds = true;
  bool _vibration = true;
  bool _biometricLock = false;

  String _language = 'English';
  String _privacyMode = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _sectionTitle('Appearance'),
          _card(
            children: [
              _switchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark mode',
                subtitle: 'Reduce brightness and eye strain',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              _divider(),
              _navTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _language,
                onTap: () => _pickLanguage(context),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _sectionTitle('Notifications'),
          _card(
            children: [
              _switchTile(
                icon: Icons.notifications_active_outlined,
                title: 'Push notifications',
                subtitle: 'Reminders, updates, and messages',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              _divider(),
              _switchTile(
                icon: Icons.volume_up_outlined,
                title: 'Sounds',
                subtitle: 'Notification sounds',
                value: _sounds,
                onChanged: (v) => setState(() => _sounds = v),
              ),
              _divider(),
              _switchTile(
                icon: Icons.vibration_outlined,
                title: 'Vibration',
                subtitle: 'Haptic feedback for alerts',
                value: _vibration,
                onChanged: (v) => setState(() => _vibration = v),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _sectionTitle('Privacy & Security'),
          _card(
            children: [
              _navTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy mode',
                subtitle: _privacyMode,
                onTap: () => _pickPrivacyMode(context),
              ),
              _divider(),
              _switchTile(
                icon: Icons.fingerprint_outlined,
                title: 'Biometric lock',
                subtitle: 'Require fingerprint/face to open app',
                value: _biometricLock,
                onChanged: (v) => setState(() => _biometricLock = v),
              ),
              _divider(),
              _navTile(
                icon: Icons.delete_outline,
                title: 'Clear local data',
                subtitle: 'Reset app preferences on this device',
                danger: true,
                onTap: _confirmClearLocalData,
              ),
            ],
          ),

          const SizedBox(height: 14),

          _sectionTitle('Support'),
          _card(
            children: [
              _navTile(
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Common questions and guidance',
                onTap: () => _snack('Help & FAQ is not connected yet.'),
              ),
              _divider(),
              _navTile(
                icon: Icons.info_outline,
                title: 'About PsyCare',
                subtitle: 'Version, policy, and app info',
                onTap: () => _showAbout(context),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _card(
            children: [
              _navTile(
                icon: Icons.logout,
                title: 'Log out',
                subtitle: 'Return to login screen',
                danger: true,
                onTap: () {
                  // IMPORTANT: keep your existing logout logic in home_screen.dart if you already have it.
                  // Here we just pop back.
                  Navigator.of(context).pop();
                  _snack('Logout action should be handled from Home screen.');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- UI Helpers ----------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: 0,
            offset: Offset(0, 10),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, color: AppColors.border);

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      secondary: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.text,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final titleColor = danger ? const Color(0xFFB42318) : AppColors.text;
    final iconColor = danger ? const Color(0xFFB42318) : AppColors.primary;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: danger ? const Color(0xFFFEE4E2) : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
    );
  }

  // ---------- Actions ----------

  Future<void> _pickLanguage(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _bottomSheetPicker(
        title: 'Language',
        items: const ['English', 'Arabic', 'Spanish', 'Greek'],
        selected: _language,
      ),
    );

    if (result != null) setState(() => _language = result);
  }

  Future<void> _pickPrivacyMode(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _bottomSheetPicker(
        title: 'Privacy mode',
        items: const ['Standard', 'Private (hide previews)', 'Strict (lock sensitive screens)'],
        selected: _privacyMode,
      ),
    );

    if (result != null) setState(() => _privacyMode = result);
  }

  Widget _bottomSheetPicker({
    required String title,
    required List<String> items,
    required String selected,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...items.map((e) {
              final isSelected = e == selected;
              return ListTile(
                onTap: () => Navigator.pop(context, e),
                title: Text(
                  e,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.primary : AppColors.text,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.circle_outlined, color: AppColors.textMuted),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmClearLocalData() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Clear local data?',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.text),
        ),
        content: const Text(
          'This will reset settings on this device. It will not delete your account.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB42318)),
            onPressed: () {
              setState(() {
                _darkMode = false;
                _pushNotifications = true;
                _sounds = true;
                _vibration = true;
                _biometricLock = false;
                _language = 'English';
                _privacyMode = 'Standard';
              });
              Navigator.pop(context);
              _snack('Local settings cleared.');
            },
            child: const Text('Clear'),
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
        title: const Text(
          'About PsyCare',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.text),
        ),
        content: const Text(
          'PsyCare is a mental wellness app prototype.\n\n'
              'Includes assessment flow, therapist review, and chat.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
