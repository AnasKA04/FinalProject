import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../home/home_screen.dart';
import 'sign_up_form_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _goToForm(BuildContext context, UserRole role) {
    Navigator.of(context).push(
      AppTransitions.fadeSlide(SignUpFormScreen(role: role)),
    );
  }

  void _continueAnonymous(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      AppTransitions.fadeSlide(const HomeScreen(isAnonymous: true)),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Create your account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose your role. You can also continue anonymously if you prefer.",
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 22),

              _RoleCard(
                title: "Sign up as Therapist",
                subtitle: "Create your professional space to support patients.",
                icon: Icons.medical_services_rounded,
                onTap: () => _goToForm(context, UserRole.therapist),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                title: "Sign up as Patient",
                subtitle: "Start your calm journey with privacy and care.",
                icon: Icons.person_rounded,
                onTap: () => _goToForm(context, UserRole.patient),
              ),

              const Spacer(),
              AppButton(
                label: "Continue as Anonymous",
                icon: Icons.visibility_off_rounded,
                isSecondary: true,
                onPressed: () => _continueAnonymous(context),
              ),
              const SizedBox(height: 10),
              Text(
                "No pressure. You’re always in control.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
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
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.35,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
