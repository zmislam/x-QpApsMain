import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../routes/app_pages.dart';
import '../controllers/marketplace_controller.dart';

class MarketplaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MarketplaceController controller;

  const MarketplaceAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Marketplace'.tr,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        // ─── My Account / Seller Panel menu ───────────────
        Semantics(
          button: true,
          label: 'Marketplace menu',
          child: IconButton(
            onPressed: () => _showMarketplaceMenu(context),
            icon: const Icon(Icons.menu, size: 24),
            tooltip: 'Marketplace menu',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Builder(
          builder: (ctx) => Divider(
              height: 1,
              thickness: 1,
              color: MarketplaceDesignTokens.divider(ctx)),
        ),
      ),
    );
  }

  void _showMarketplaceMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.divider(ctx),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Marketplace Menu',
                    style: MarketplaceDesignTokens.sectionTitle(ctx),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Buyer panel
              _MenuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Buyer Panel',
                subtitle: 'Orders, reviews, returns & more',
                color: MarketplaceDesignTokens.primary,
                textColor: textColor,
                onTap: () {
                  Navigator.pop(ctx);
                  Get.toNamed(Routes.MARKETPLACE_BUYER_PANEL);
                },
              ),
              // Seller panel
              _MenuTile(
                icon: Icons.storefront_outlined,
                title: 'Seller Panel',
                subtitle: 'Products, orders, payments & store',
                color: const Color(0xFFE67E22),
                textColor: textColor,
                onTap: () {
                  Navigator.pop(ctx);
                  Get.toNamed(Routes.MARKETPLACE_SELLER_PANEL);
                },
              ),
              // Wishlist
              _MenuTile(
                icon: Icons.favorite_border,
                title: 'Wishlist',
                subtitle: 'Saved products',
                color: Colors.redAccent,
                textColor: textColor,
                onTap: () {
                  Navigator.pop(ctx);
                  Get.toNamed(Routes.WISHLIST_PAGE);
                },
              ),
              // Cart
              _MenuTile(
                icon: Icons.shopping_cart_outlined,
                title: 'My Cart',
                subtitle: 'View and manage cart items',
                color: MarketplaceDesignTokens.primary,
                textColor: textColor,
                onTap: () {
                  Navigator.pop(ctx);
                  Get.toNamed(Routes.CART);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.4), size: 22),
          ],
        ),
      ),
    );
  }
}
