import 'package:flutter/material.dart';
import '../../../config/constants/color.dart';

/// Tip button for profile/post — opens tip modal.
class TipButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact;

  const TipButton({
    super.key,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: PRIMARY_COLOR.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.monetization_on_outlined,
              size: 18, color: PRIMARY_COLOR),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: PRIMARY_COLOR.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: PRIMARY_COLOR.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monetization_on_outlined,
                size: 16, color: PRIMARY_COLOR),
            const SizedBox(width: 6),
            Text(
              'Tip',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
