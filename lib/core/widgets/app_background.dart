import 'package:flutter/material.dart';

/// Clean, theme-aware background used across screens.
///
/// The target look is “wellness app”: mostly neutral and bright, with a subtle
/// top tint that pairs nicely with teal/indigo accents.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Soft top-tint gradient (kept very subtle to resemble Wysa-style UIs)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cs.primary.withOpacity(0.08),
                  cs.background,
                  cs.background,
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
            ),
          ),
        ),

        // A very light “wash” on the bottom for depth
        Positioned(
          left: 0,
          right: 0,
          bottom: -120,
          child: IgnorePointer(
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.2,
                  center: const Alignment(0.0, 0.0),
                  colors: [
                    cs.tertiary.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Foreground
        Positioned.fill(child: child),
      ],
    );
  }
}
