import 'package:flutter/material.dart';

/// Badge shown above pinned comments.
class PinnedCommentBadge extends StatelessWidget {
  const PinnedCommentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.push_pin,
          color: Colors.white38,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          'Pinned by creator',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
