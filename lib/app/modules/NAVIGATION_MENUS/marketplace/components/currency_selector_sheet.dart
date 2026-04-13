import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../services/currency_service.dart';

/// A bottom sheet that lets the user pick their preferred display currency.
class CurrencySelectorSheet extends StatelessWidget {
  const CurrencySelectorSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const CurrencySelectorSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = CurrencyService.instance;
    final currencies = CurrencyService.supportedCurrencies;

    return Container(
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(MarketplaceDesignTokens.radiusMd),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Handle ──────────────────────────
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.divider(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ─── Title ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd),
              child: Row(
                children: [
                  Icon(Icons.currency_exchange,
                      size: 22, color: MarketplaceDesignTokens.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Display Currency'.tr,
                    style: MarketplaceDesignTokens.sectionTitle(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Prices are converted for display only. All transactions use EUR.'
                      .tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─── Currency List ───────────────────
            ...currencies.entries.map((entry) {
              final code = entry.key;
              final meta = entry.value;
              return Obx(() {
                final isSelected = service.selectedCurrency.value == code;
                return InkWell(
                  onTap: () {
                    service.setCurrency(code);
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MarketplaceDesignTokens.spacingMd,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MarketplaceDesignTokens.primary.withValues(alpha: 0.08)
                          : null,
                      border: Border(
                        bottom: BorderSide(
                          color: MarketplaceDesignTokens.divider(context),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(meta.flag, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$code – ${meta.name}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: MarketplaceDesignTokens.textPrimary(
                                      context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Symbol: ${meta.symbol}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MarketplaceDesignTokens.textSecondary(
                                      context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle,
                              color: MarketplaceDesignTokens.primary, size: 22),
                      ],
                    ),
                  ),
                );
              });
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
