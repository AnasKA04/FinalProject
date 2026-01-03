import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/theme/app_colors.dart';

import '../home/home_screen.dart';
import 'sign_up_form_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _goToForm(BuildContext context, UserRole role) {
    Navigator.of(context).push(
      AppTransitions.fadeSlide(SignUpFormScreen(role: role)),
    );
  }

  void _goToLogin(BuildContext context) {
    // Works even if navigation stack was cleared
    Navigator.of(context).pushAndRemoveUntil(
      AppTransitions.fadeSlide(const LoginScreen()),
          (route) => false,
    );
  }

  void _continueAnonymous(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      AppTransitions.fadeSlide(
        const HomeScreen(
          isAnonymous: true,
          role: UserRole.patient,
          displayName: 'Friend',
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => _goToLogin(context), // ✅ always returns to Login
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _roleCard(
              context: context,
              icon: Icons.person_outline,
              title: 'Create as Patient',
              subtitle: 'Track your wellbeing and chat with your therapist.',
              onTap: () => _goToForm(context, UserRole.patient),
            ),
            const SizedBox(height: 12),
            _roleCard(
              context: context,
              icon: Icons.medical_services_outlined,
              title: 'Create as Therapist',
              subtitle: 'Review assessments and support patients safely.',
              onTap: () => _goToForm(context, UserRole.therapist),
            ),
            const Spacer(),

            // Continue anonymously
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _continueAnonymous(context),
                icon: const Icon(Icons.visibility_off_outlined),
                label: const Text('Continue anonymously'),
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Add back "Login" access (same concept as typical Flutter auth flows)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                TextButton(
                  onPressed: () => _goToLogin(context),
                  child: const Text('Login'),
                ),
              ],
            ),

            Text(
              'Your privacy matters. We keep the experience calm and minimal.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _roleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primarySoft,
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
