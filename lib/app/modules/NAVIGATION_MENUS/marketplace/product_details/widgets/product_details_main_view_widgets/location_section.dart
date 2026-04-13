import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class LocationSection extends GetView<ProductDetailsController> {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final location = controller.product.value?.location;
      if (location == null || (!location.hasAddress && !location.hasCoordinates)) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Section Header ──────────────────
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: MarketplaceDesignTokens.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Item Location'.tr,
                  style: MarketplaceDesignTokens.sectionTitle(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Address ─────────────────────────
            if (location.hasAddress)
              Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location.displayAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: MarketplaceDesignTokens.textSecondary(context),
                      ),
                    ),
                  ),
                ],
              ),

            // ─── Radius info ─────────────────────
            if (location.radius != null && location.radius! > 0) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.radar_outlined,
                    size: 16,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${'Delivery radius'.tr}: ${location.radius!.toStringAsFixed(0)} km',
                    style: TextStyle(
                      fontSize: 13,
                      color: MarketplaceDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ],

            // ─── View on Map Button ──────────────
            if (location.hasCoordinates) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openInMaps(location.lat!, location.lng!),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: Text('View on Map'.tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MarketplaceDesignTokens.primary,
                    side: BorderSide(
                      color: MarketplaceDesignTokens.primary.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Future<void> _openInMaps(double lat, double lng) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
