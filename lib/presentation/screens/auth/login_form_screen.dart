import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/auth/auth_store.dart';
import '../main/main_nav_screen.dart';
import '../main/admin_nav_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key, required this.role});
  final UserRole role;

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

  void _login() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final result = AuthStore.instance.login(
      role: widget.role,
      email: _email.text,
      password: _password.text,
    );

    if (!result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? "Login failed.")),
      );
      return;
    }

    final user = result.user!;

    final next = (user.role == UserRole.admin)
        ? AdminNavScreen(displayName: user.displayName)
        : MainNavScreen(
          isAnonymous: false,
          role: user.role,
          displayName: user.displayName,
        );

    Navigator.of(context).pushAndRemoveUntil(
      AppTransitions.fadeSlide(next),
          (route) => false,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
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
                    label: "Login",
                    icon: Icons.login_rounded,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Demo accounts:\ntherapist@psycare.app / 123456\npatient@psycare.app / 123456",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
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

