import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/navigation/app_transitions.dart';
import '../auth/login_screen.dart';
import '../main/main_nav_screen.dart';
import '../../../core/models/user_role.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import 'package:psycare/serviece/booking_serviece.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _Header(),
              const SizedBox(height: 26),
              Expanded(
                child: _CalmHeroCard(),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: "Continue as Anonymous",
                isSecondary: true,
                icon: Icons.visibility_off_rounded,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    AppTransitions.fadeSlide(
                      const MainNavScreen(isAnonymous: true, role: UserRole.patient),
                    ),
                  );
                },
              ),
              AppButton(
                label: "Get Started",
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    AppTransitions.fadeSlide(const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                "By continuing, you agree to a calm and safe experience.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 6),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Icon(Icons.favorite_rounded, color: cs.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "PsyCare",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 2),
            Text(
              "A calm space for support",
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalmHeroCard extends StatefulWidget {
  @override
  State<_CalmHeroCard> createState() => _CalmHeroCardState();
}

class _CalmHeroCardState extends State<_CalmHeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _scale = Tween<double>(begin: 0.98, end: 1).animate(curved);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SoftBadge(),
              const SizedBox(height: 16),
              const Text(
                "Feel heard.\nFeel safe.",
                style: TextStyle(
                  fontSize: 30,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose the right path for you — therapist or patient — and start with a simple, calm experience.",
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.55,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.accent),
                      SizedBox(width: 8),
                      Text(
                        "Private • Supportive • Simple",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spa_rounded, size: 16, color: cs.primary),
          SizedBox(width: 8),
          Text(
            "Trusted care, calm design",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.primary),
          ),
        ],
      ),
    );
  }
}
