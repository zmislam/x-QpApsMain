import 'package:flutter/material.dart';

/// Verified badge — blue checkmark icon used across reel widgets.
class VerifiedBadge extends StatelessWidget {
  final double size;

  const VerifiedBadge({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      color: const Color(0xFF1DA1F2),
      size: size,
    );
  }
}
