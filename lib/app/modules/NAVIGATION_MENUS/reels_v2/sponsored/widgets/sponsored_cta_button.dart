import 'package:flutter/material.dart';

/// Call-to-action button rendered at the bottom of a sponsored reel.
/// Dynamically shows the CTA label from the ad configuration.
class SponsoredCtaButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SponsoredCtaButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconForLabel(label),
              color: Colors.black87,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('shop')) return Icons.shopping_bag_outlined;
    if (lower.contains('sign up')) return Icons.person_add_outlined;
    if (lower.contains('download')) return Icons.download_outlined;
    if (lower.contains('contact')) return Icons.message_outlined;
    if (lower.contains('book')) return Icons.calendar_today_outlined;
    if (lower.contains('watch')) return Icons.play_circle_outline;
    if (lower.contains('install')) return Icons.install_mobile_outlined;
    return Icons.open_in_new;
  }
}
