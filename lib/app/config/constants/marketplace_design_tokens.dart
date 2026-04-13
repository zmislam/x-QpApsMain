import 'package:flutter/material.dart';
import 'feed_design_tokens.dart';

/// Marketplace design tokens — centralized colors, dimensions, typography, and shadows.
/// Reuses FeedDesignTokens for card/text consistency, adds marketplace-specific tokens.
class MarketplaceDesignTokens {
  MarketplaceDesignTokens._();

  // ─── Colors (shared with Feed) ───────────────────────────
  static Color cardBg(BuildContext context) => FeedDesignTokens.cardBg(context);
  static Color cardBorder(BuildContext context) => FeedDesignTokens.cardBorder(context);
  static Color textPrimary(BuildContext context) => FeedDesignTokens.textPrimary(context);
  static Color textSecondary(BuildContext context) => FeedDesignTokens.textSecondary(context);
  static Color divider(BuildContext context) => FeedDesignTokens.divider(context);

  // ─── Pricing Colors ──────────────────────────────────────
  static const Color pricePrimary = Color(0xFF307777);   // teal — selling price
  static const Color priceOriginal = Color(0xFF65676B);   // grey — crossed-out original
  static const Color priceDiscount = Color(0xFFE53935);   // red — discount badge

  // ─── Rating Colors ───────────────────────────────────────
  static const Color ratingStarFill = Color(0xFFFF9017);  // orange
  static const Color ratingStarEmpty = Color(0xFFD1D5DB); // grey

  // ─── Inventory Status Colors ─────────────────────────────
  static const Color inStock = Color(0xFF43A047);         // green
  static const Color outOfStock = Color(0xFFE53935);      // red
  static const Color lowStock = Color(0xFFFB8C00);        // amber

  // ─── Badge Colors ────────────────────────────────────────
  static const Color badgeBg = Color(0xFFE8F5E9);        // light green
  static const Color sellerBadge = Color(0xFF1877F2);     // blue — verified seller
  static const Color buyerBadge = Color(0xFF43A047);      // green — verified purchase

  // ─── Order Status Colors ─────────────────────────────────
  static const Color orderPending = Color(0xFFFB8C00);    // amber
  static const Color orderProcessing = Color(0xFF1877F2); // blue
  static const Color orderAccepted = Color(0xFF307777);   // teal
  static const Color orderDelivered = Color(0xFF43A047);  // green
  static const Color orderCancelled = Color(0xFFE53935);  // red
  static const Color orderRefund = Color(0xFF9C27B0);     // purple

  // ─── Refund Status Colors ────────────────────────────────
  static const Color refundPending = Color(0xFFFB8C00);   // amber
  static const Color refundAccepted = Color(0xFF43A047);  // green
  static const Color refundDeclined = Color(0xFFE53935);  // red
  static const Color refundSent = Color(0xFF1877F2);      // blue
  static const Color refundReceived = Color(0xFF307777);  // teal
  static const Color refundRefunded = Color(0xFF43A047);  // green
  static const Color refundSolved = Color(0xFF43A047);    // green

  // ─── Dimensions ──────────────────────────────────────────
  static const double cardRadius = 12.0;
  static const double cardPadding = 12.0;
  static const double gridSpacing = 10.0;
  static const double sectionSpacing = 16.0;
  static const double chipHeight = 36.0;
  static const double productImageH = 180.0;
  static const double carouselHeight = 220.0;
  static const double thumbnailSize = 60.0;
  static const double avatarSize = 40.0;

  // Spacing aliases (for convenience)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;

  // Radius aliases
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;

  // Primary color alias
  static const Color primary = pricePrimary;

  // Shadow helpers
  static List<BoxShadow> shadowSm(BuildContext context) => const [cardShadow];
  static List<BoxShadow> shadowMd(BuildContext context) => const [elevatedShadow];

  // ─── Typography ──────────────────────────────────────────
  static TextStyle productName(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary(context),
        overflow: TextOverflow.ellipsis,
      );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: pricePrimary,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary(context),
      );

  static TextStyle cardSubtext(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary(context),
      );

  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle statValue(BuildContext context) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary(context),
      );

  // ─── Shadows ─────────────────────────────────────────────
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0D000000), // black 5%
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x1A000000), // black 10%
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  // ─── Decoration Helpers ──────────────────────────────────
  static BoxDecoration cardDecoration(BuildContext context) => BoxDecoration(
        color: cardBg(context),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: cardBorder(context)),
        boxShadow: const [cardShadow],
      );

  // ─── Order Status Helpers ────────────────────────────────
  static Color orderStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return orderPending;
      case 'onprocessing':
        return orderProcessing;
      case 'accepted':
        return orderAccepted;
      case 'delivered':
        return orderDelivered;
      case 'canceled':
        return orderCancelled;
      case 'refund':
        return orderRefund;
      default:
        return orderPending;
    }
  }

  static String orderStatusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'onprocessing':
        return 'Processing';
      case 'accepted':
        return 'Accepted';
      case 'delivered':
        return 'Delivered';
      case 'canceled':
        return 'Cancelled';
      case 'refund':
        return 'Refund';
      default:
        return status ?? 'Unknown';
    }
  }

  static Color refundStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return refundPending;
      case 'accepted':
        return refundAccepted;
      case 'declined':
        return refundDeclined;
      case 'sent':
        return refundSent;
      case 'received':
        return refundReceived;
      case 'refunded':
        return refundRefunded;
      case 'solved':
        return refundSolved;
      default:
        return refundPending;
    }
  }

  // ─── Additional Typography ───────────────────────────────
  static TextStyle statLabel(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary(context),
      );

  static TextStyle bodyText(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary(context),
      );

  static TextStyle bodyTextSmall(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textPrimary(context),
      );

  static TextStyle heading(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary(context),
      );
}
