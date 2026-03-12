import 'package:flutter/material.dart';

/// Facebook-inspired design tokens for the newsfeed.
/// Centralized color & dimension constants for light/dark mode parity.
class FeedDesignTokens {
  FeedDesignTokens._();

  // ─── Card ────────────────────────────────────────────────
  static const Color cardBgLight = Color(0xFFFFFFFF);
  static const Color cardBgDark = Color(0xFF242526);

  static const Color cardBorderLight = Color(0xFFE4E6EB);
  static const Color cardBorderDark = Color(0xFF3A3B3C);

  // ─── Text ────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF050505);
  static const Color textPrimaryDark = Color(0xFFE4E6EB);

  static const Color textSecondaryLight = Color(0xFF65676B);
  static const Color textSecondaryDark = Color(0xFFB0B3B8);

  // ─── Surfaces ────────────────────────────────────────────
  static const Color inputBgLight = Color(0xFFF0F2F5);
  static const Color inputBgDark = Color(0xFF3A3B3C);

  static const Color hoverBgLight = Color(0xFFF0F2F5);
  static const Color hoverBgDark = Color(0xFF3A3B3C);

  // ─── Brand ───────────────────────────────────────────────
  static const Color brandLight = Color(0xFF1877F2);
  static const Color brandDark = Color(0xFF2D88FF);

  // ─── Comment Bubble ──────────────────────────────────────
  static const Color commentBubbleLight = Color(0xFFF0F2F5);
  static const Color commentBubbleDark = Color(0xFF3A3B3C);

  // ─── Divider ─────────────────────────────────────────────
  static const Color dividerLight = Color(0xFFE4E6EB);
  static const Color dividerDark = Color(0xFF3A3B3C);

  // ─── Helpers ─────────────────────────────────────────────

  static Color cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardBgDark : cardBgLight;

  static Color cardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardBorderDark
          : cardBorderLight;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textPrimaryDark
          : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textSecondaryDark
          : textSecondaryLight;

  static Color inputBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? inputBgDark
          : inputBgLight;

  static Color hoverBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? hoverBgDark
          : hoverBgLight;

  static Color brand(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? brandDark : brandLight;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dividerDark
          : dividerLight;

  static Color commentBubble(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? commentBubbleDark
          : commentBubbleLight;

  // ─── Dimensions ──────────────────────────────────────────
  static const double avatarSize = 40.0;
  static const double commentAvatarSize = 32.0;
  static const double replyAvatarSize = 28.0;
  static const double nameSize = 15.0;
  static const double timeSize = 13.0;
  static const double bodyTextSize = 15.0;
  static const double actionButtonSize = 15.0;
  static const double commentTextSize = 15.0;
  static const double whyShownSize = 11.0;

  static const double postCardBorderRadius = 0.0; // full-width on mobile
  static const double commentBubbleRadius = 18.0;
  static const double inputBorderRadius = 20.0;
  static const double menuItemRadius = 8.0;
  static const double threeDotButtonSize = 36.0;

  // ─── Story Card Dimensions ───────────────────────────────
  static const double storyCardHeight = 200.0;
  static const double storyCardWidth = 112.0;
  static const double storyCardRadius = 12.0;
  static const double storyAvatarSize = 36.0;
  static const double storyCreatePlusSize = 32.0;
  static const double storyGap = 8.0;

  // ─── Action Bar ─────────────────────────────────────────
  static const double actionBarHeight = 44.0;
  static const double actionIconSize = 20.0;
  static const double reactionIconSize = 18.0;
  static const double reactionIconSizeLarge = 20.0;
  static const double cardPaddingH = 12.0;
  static const double cardPaddingV = 12.0;
  static const double separatorHeight = 8.0;

  // ─── Separator ──────────────────────────────────────────
  static Color separator(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A3B3C)
          : const Color(0xFFE4E6EB);

  static Color surfaceBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF18191A)
          : const Color(0xFFF0F2F5);
  static TextStyle countStyle(BuildContext context) => TextStyle(
        fontSize: timeSize,
        color: textSecondary(context),
      );
}
