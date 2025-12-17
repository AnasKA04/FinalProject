import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../home/home_screen.dart';
import '../../../core/navigation/app_transitions.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
    );
  }

  void _createAccount() {
    // Placeholder logic for now (next step: local storage + validation)
        Navigator.of(context).pushAndRemoveUntil(
          AppTransitions.fadeSlide(
            HomeScreen(
              isAnonymous: false,
              role: widget.role,
              displayName: _name.text.trim().isEmpty ? widget.role.label : _name.text.trim(),
            ),
          ),
              (route) => false,
        );

    }

  @override
  Widget build(BuildContext context) {
    final roleLabel = widget.role.label;

    return Scaffold(
      appBar: AppBar(
        title: Text("$roleLabel Sign Up"),
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
              Text(
                "Create a $roleLabel account",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                "Just a few details to get started.",
                style: TextStyle(color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: _dec("Full Name", Icons.badge_outlined),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _dec("Email", Icons.mail_outline_rounded),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: _dec("Password", Icons.lock_outline_rounded),
              ),

              const Spacer(),
              AppButton(
                label: "Create Account",
                icon: Icons.check_circle_outline_rounded,
                onPressed: _createAccount,
              ),
              const SizedBox(height: 10),
              Text(
                "You can update your details later. Take it one step at a time.",
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
