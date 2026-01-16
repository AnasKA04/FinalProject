import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/auth/auth_store.dart';

import '../main/main_nav_screen.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import '../../main/main_nav_screen.dart'; // adjust path

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key, required this.role});
  final UserRole role;

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
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = AuthService();

    try {
      await auth.signUpEmailPassword(
        email: _email.text.trim(),
        password: _password.text,
        fullName: _name.text.trim(),
        role: widget.role, // UserRole.patient or UserRole.therapist
      );

      // Optional: fetch name again from Firestore if you want
      final fullName = await auth.getCurrentUserFullName();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppTransitions.fadeSlide(
          MainNavScreen(
            isAnonymous: false,
            role: widget.role,
            displayName: fullName ?? _name.text.trim(),
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
                  const SizedBox(height: 6),
                  Text(
                    "Create your $roleLabel account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your data stays on this device for now (demo mode).",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 26),

                  TextFormField(
                    controller: _name,
                    decoration: _dec("Full Name", Icons.person_outline_rounded),
                    validator: (v) {
                      final value = (v ?? "").trim();
                      if (value.isEmpty) return "Name is required.";
                      if (value.length < 2) return "Name is too short.";
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dec("Email", Icons.email_outlined),
                    validator: (v) {
                      final value = (v ?? "").trim();
                      if (value.isEmpty) return "Email is required.";
                      if (!value.contains("@") || !value.contains(".")) {
                        return "Enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: _dec("Password", Icons.lock_outline_rounded),
                    validator: (v) {
                      final value = (v ?? "");
                      if (value.isEmpty) return "Password is required.";
                      if (value.length < 6) return "Password must be at least 6 characters.";
                      return null;
                    },
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
