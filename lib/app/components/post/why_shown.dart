import 'package:flutter/material.dart';

import '../../config/constants/feed_design_tokens.dart';
import '../../models/post.dart';

/// Attractive "Why you're seeing this" badge with context-aware text.
///
/// Shows contextual labels like "Page suggested for you", "Group suggested
/// for you", "Posted by your friend", etc. — with a modern branded design.
class WhyShownWidget extends StatelessWidget {
  const WhyShownWidget({
    super.key,
    required this.text,
    this.model,
    this.onTapMenu,
    this.onTapClose,
  });

  final String text;
  final PostModel? model;
  final VoidCallback? onTapMenu;
  final VoidCallback? onTapClose;

  /// Determines the display text based on post context.
  /// For "Suggested for you" labels, prefixes with Page/Group when applicable.
  String get _displayText {
    if (model == null) return text;
    final lower = text.toLowerCase();

    // Only modify generic "suggested for you" labels
    if (lower == 'suggested for you') {
      final isPage = (model!.page_id.pageName?.length ?? 0) > 1;
      final isGroup = (model!.groupId.groupName?.length ?? 0) > 1;
      if (isPage) return 'Page suggested for you';
      if (isGroup) return 'Group suggested for you';
    }

    return text;
  }

  /// Returns an appropriate icon based on context.
  _BadgeStyle get _badgeStyle {
    if (model != null) {
      final lower = text.toLowerCase();
      if (lower == 'suggested for you') {
        final isPage = (model!.page_id.pageName?.length ?? 0) > 1;
        final isGroup = (model!.groupId.groupName?.length ?? 0) > 1;
        if (isPage) {
          return _BadgeStyle(
            icon: Icons.flag_rounded,
            gradientColors: [Color(0xFF307777), Color(0xFF21CBC1)],
          );
        }
        if (isGroup) {
          return _BadgeStyle(
            icon: Icons.group_rounded,
            gradientColors: [Color(0xFF307777), Color(0xFF21CBC1)],
          );
        }
      }
      if (lower.contains('friend')) {
        return _BadgeStyle(
          icon: Icons.people_alt_rounded,
          gradientColors: [Color(0xFF307777), Color(0xFF21CBC1)],
        );
      }
      if (lower.contains('popular')) {
        return _BadgeStyle(
          icon: Icons.local_fire_department_rounded,
          gradientColors: [Color(0xFFFF6B35), Color(0xFFFF9F1C)],
        );
      }
      if (lower.contains('follow')) {
        return _BadgeStyle(
          icon: Icons.person_add_alt_1_rounded,
          gradientColors: [Color(0xFF307777), Color(0xFF21CBC1)],
        );
      }
      if (lower.contains('mentioned')) {
        return _BadgeStyle(
          icon: Icons.alternate_email_rounded,
          gradientColors: [Color(0xFF5B5FC7), Color(0xFF7B83EB)],
        );
      }
    }
    // Default: sparkle with QP brand gradient
    return _BadgeStyle(
      icon: Icons.auto_awesome,
      gradientColors: [Color(0xFF307777), Color(0xFF21CBC1)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = _badgeStyle;
    final label = _displayText;

    return Padding(
      padding: const EdgeInsets.only(
        left: FeedDesignTokens.cardPaddingH,
        right: FeedDesignTokens.cardPaddingH,
        top: 10,
        bottom: 2,
      ),
      child: Row(
        children: [
          // ─── Gradient icon in a subtle pill ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? style.gradientColors
                        .map((c) => c.withValues(alpha: 0.15))
                        .toList()
                    : style.gradientColors
                        .map((c) => c.withValues(alpha: 0.10))
                        .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: style.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Icon(
                    style.icon,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? style.gradientColors
                            .map((c) => Color.lerp(c, Colors.white, 0.3)!)
                            .toList()
                        : style.gradientColors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.1,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (onTapMenu != null || onTapClose != null) ...[
            if (onTapMenu != null)
              GestureDetector(
                onTap: onTapMenu,
                child: Icon(
                  Icons.more_horiz,
                  size: 22,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
            if (onTapClose != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onTapClose,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Internal helper for badge styling per context.
class _BadgeStyle {
  final IconData icon;
  final List<Color> gradientColors;

  const _BadgeStyle({
    required this.icon,
    required this.gradientColors,
  });
}
