import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/welcome/welcome_screen.dart';

class PsyCareApp extends StatelessWidget {
  const PsyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PsyCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
