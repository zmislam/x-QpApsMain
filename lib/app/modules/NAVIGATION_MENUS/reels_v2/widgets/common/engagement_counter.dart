import 'package:flutter/material.dart';

/// Animated engagement counter — animates text changes with a slide effect.
class EngagementCounter extends StatelessWidget {
  final String count;
  final TextStyle? style;

  const EngagementCounter({
    super.key,
    required this.count,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        count,
        key: ValueKey(count),
        style: style ??
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
