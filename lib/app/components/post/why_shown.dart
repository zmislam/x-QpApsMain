import 'package:flutter/material.dart';

import '../../config/constants/feed_design_tokens.dart';

/// Compact "Why you're seeing this" badge (EdgeRank context)
class WhyShownWidget extends StatelessWidget {
  const WhyShownWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: FeedDesignTokens.cardPaddingH,
        right: FeedDesignTokens.cardPaddingH,
        top: 8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 14,
            color: FeedDesignTokens.textSecondary(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: FeedDesignTokens.whyShownSize,
                color: FeedDesignTokens.textSecondary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
