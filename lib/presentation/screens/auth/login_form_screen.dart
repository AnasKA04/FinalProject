import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
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

  void _login() {
    // Placeholder for now (next steps: validation + storage/auth logic)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logging in as ${widget.role.label}... (next step)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = widget.role.label;

    return Scaffold(
      appBar: AppBar(
        title: Text("$roleLabel Login"),
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
                "Sign in as $roleLabel",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your details to continue.",
                style: TextStyle(color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
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
                label: "Login",
                icon: Icons.login_rounded,
                onPressed: _login,
              ),
              const SizedBox(height: 10),
              Text(
                "If you feel overwhelmed, take a breath — you’re safe here.",
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
