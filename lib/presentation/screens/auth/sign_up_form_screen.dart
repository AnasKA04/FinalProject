import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart' as ui;
import '../../../core/navigation/app_transitions.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_button.dart';

import 'package:psycare/serviece/auth_serviece.dart';
import 'package:psycare/presentation/screens/main/main_nav_screen.dart';
import '../../../models/enums.dart' as db;

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key, required this.role});
  final ui.UserRole role;

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
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

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
  );

  Future<void> _createAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = AuthService();

    // Convert UI role -> DB role
    final db.UserRole dbRole =
    widget.role == ui.UserRole.therapist
        ? db.UserRole.therapist
        : db.UserRole.patient;

    try {
      await auth.signUpEmailPassword(
        email: _email.text.trim(),
        password: _password.text,
        fullName: _name.text.trim(),
        role: dbRole,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppTransitions.fadeSlide(
          MainNavScreen(
            isAnonymous: false,
            role: widget.role,
            displayName: _name.text.trim(),
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    }
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
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: _dec("Full Name", Icons.person_outline_rounded),
                    validator: (v) =>
                    (v ?? "").length < 2 ? "Name too short" : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    decoration: _dec("Email", Icons.email_outlined),
                    validator: (v) =>
                    (v ?? "").contains("@") ? null : "Invalid email",
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: _dec("Password", Icons.lock_outline_rounded),
                    validator: (v) =>
                    (v ?? "").length < 6 ? "Password too short" : null,
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: "Create Account",
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: _createAccount,
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
