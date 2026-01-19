import 'package:flutter/material.dart';

import '../../../core/navigation/app_transitions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/models/user_role.dart' as ui;

import '../main/main_nav_screen.dart';
import 'package:psycare/serviece/auth_serviece.dart';
import '../../../models/enums.dart' as db;

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key, required this.role});
  final ui.UserRole role;

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
  );

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = AuthService();

    try {
      await auth.loginEmailPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      // Read role from Firestore (DB enum)
      final db.UserRole? dbRole = await auth.getCurrentUserRole();

      // Convert DB enum -> UI enum
      ui.UserRole? uiRole;
      if (dbRole == db.UserRole.therapist) {
        uiRole = ui.UserRole.therapist;
      } else if (dbRole == db.UserRole.patient) {
        uiRole = ui.UserRole.patient;
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppTransitions.fadeSlide(
          MainNavScreen(
            isAnonymous: false,
            role: uiRole,
            displayName: null, // fetched later in profile
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
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
                    "Welcome back",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login as $roleLabel to continue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dec("Email", Icons.email_outlined),
                    validator: (v) {
                      final value = (v ?? "").trim();
                      if (value.isEmpty) return "Email is required.";
                      if (!value.contains("@")) return "Invalid email.";
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: _dec("Password", Icons.lock_outline_rounded),
                    validator: (v) {
                      if ((v ?? "").length < 6) return "Password too short.";
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: "Login",
                    icon: Icons.login_rounded,
                    onPressed: _login,
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
