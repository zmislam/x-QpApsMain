import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../utils/currency_helper.dart';
import '../controllers/cart_controller.dart';

class PaymentStep extends GetView<CartController> {
  const PaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order Summary ──
          _buildOrderSummaryCard(context),

          const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

          // ── Payment Method ──
          Text('Payment Method',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 12),

          Obx(() => Column(
                children: [
                  _buildPaymentOption(
                    context: context,
                    method: PaymentMethod.wallet,
                    icon: Icons.account_balance_wallet,
                    title: 'QP Wallet Balance',
                    subtitle: _walletBalanceText(),
                    color: const Color(0xFF317773),
                  ),
                  _buildPaymentOption(
                    context: context,
                    method: PaymentMethod.stripe,
                    icon: Icons.credit_card,
                    title: 'Credit / Debit Card',
                    subtitle: 'Pay with Stripe',
                    color: const Color(0xFF635BFF),
                  ),
                  _buildPaymentOption(
                    context: context,
                    method: PaymentMethod.qpeu,
                    icon: Icons.euro,
                    title: 'QP Euro (QPEU)',
                    subtitle: 'Gasless blockchain payment',
                    color: const Color(0xFF2775CA),
                  ),
                  _buildPaymentOption(
                    context: context,
                    method: PaymentMethod.qpg,
                    icon: Icons.token,
                    title: 'QPG Token',
                    subtitle: 'Gasless blockchain payment',
                    color: const Color(0xFFFF9800),
                  ),
                  _buildPaymentOption(
                    context: context,
                    method: PaymentMethod.earnings,
                    icon: Icons.savings,
                    title: 'Pay with Earnings',
                    subtitle: controller.isLoadingEarningBalance.value
                        ? 'Loading balance...'
                        : 'Balance: €${controller.earningBalance.value.toStringAsFixed(2)}',
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              )),

          const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

          // ── Shipping Address Summary ──
          _buildAddressSummary(context),

          const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

          // ── Navigation Buttons ──
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: MarketplaceDesignTokens.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back,
                          color: MarketplaceDesignTokens.primary, size: 18),
                      const SizedBox(width: 4),
                      Text('Back',
                          style: TextStyle(
                              color: MarketplaceDesignTokens.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isPlacingOrder.value
                          ? null
                          : controller.placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MarketplaceDesignTokens.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MarketplaceDesignTokens.radiusMd)),
                      ),
                      child: controller.isPlacingOrder.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                    'Pay €${controller.calculateTotalPayable().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                              ],
                            ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _walletBalanceText() {
    final balance = controller.wallerSummery.value.walletBalance ?? 0.0;
    final balanceNum = balance is num ? balance.toDouble() : 0.0;
    return 'Balance: €${balanceNum.toStringAsFixed(2)}';
  }

  Widget _buildOrderSummaryCard(BuildContext context) {
    final totalItems = controller.storeDetailsList.fold<int>(
        0, (sum, store) => sum + (store.myProduct?.length ?? 0));
    final totalProductPrice = controller.calculateTotalProductPrice();
    final totalDiscount = controller.calculateTotalDiscount();
    final totalTax = controller.calculateTotalTax();
    final totalPayable = controller.calculateTotalPayable();

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long,
                  color: MarketplaceDesignTokens.primary, size: 20),
              const SizedBox(width: 8),
              Text('Order Summary',
                  style: MarketplaceDesignTokens.sectionTitle(context)),
            ],
          ),
          const SizedBox(height: 12),
          _priceRow(context, 'Items ($totalItems)',
              CurrencyHelper.formatPrice(totalProductPrice)),
          _priceRow(context, 'Shipping', 'Free', valueColor: Colors.green),
          if (totalDiscount > 0)
            _priceRow(context, 'Coupon Discount',
                '-${CurrencyHelper.formatPrice(totalDiscount)}',
                valueColor: Colors.red),
          _priceRow(
              context, 'VAT', '+${CurrencyHelper.formatPrice(totalTax)}'),
          const Divider(),
          _priceRow(context, 'Total',
              CurrencyHelper.formatPrice(totalPayable),
              isBold: true, fontSize: 18),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = controller.selectedPaymentMethod.value == method;

    return GestureDetector(
      onTap: () => controller.selectedPaymentMethod.value = method,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? color.withValues(alpha: 0.05)
              : MarketplaceDesignTokens.cardBg(context),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: MarketplaceDesignTokens.textPrimary(
                              context))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: MarketplaceDesignTokens.textSecondary(
                              context))),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSummary(BuildContext context) {
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping,
                  color: MarketplaceDesignTokens.primary, size: 20),
              const SizedBox(width: 8),
              Text('Shipping To',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                [
                  controller.selectedAddress.value,
                  if (controller.selectedCity.value.isNotEmpty)
                    controller.selectedCity.value.capitalizeFirst ?? '',
                  if (controller.contact.value.isNotEmpty)
                    'Ph: ${controller.contact.value}',
                ].where((s) => s.isNotEmpty).join('\n'),
                style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color:
                        MarketplaceDesignTokens.textSecondary(context)),
              )),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.previousStep,
            child: Text('Change Address',
                style: TextStyle(
                    color: MarketplaceDesignTokens.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? valueColor, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                fontSize: fontSize,
                color: MarketplaceDesignTokens.textPrimary(context),
              )),
          Text(value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                fontSize: fontSize,
                color: valueColor ??
                    MarketplaceDesignTokens.textPrimary(context),
              )),
        ],
      ),
    );
  }
}
