import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isSecondary ? Colors.white : AppColors.primary,
      foregroundColor: isSecondary ? AppColors.primary : Colors.white,
      side: isSecondary ? const BorderSide(color: AppColors.border) : BorderSide.none,
    );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 10),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
