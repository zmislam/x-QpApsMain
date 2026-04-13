import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/empty_state.dart';
import '../../../components/status_badge.dart';
import '../controllers/seller_payments_controller.dart';

/// Seller payments list with status filter and transfer-to-wallet action.
class SellerPaymentsView extends GetView<SellerPaymentsController> {
  const SellerPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status filter chips
        SizedBox(
          height: MarketplaceDesignTokens.chipHeight,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.cardPadding,
                  vertical: 4,
                ),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: controller.statusFilter.value.isEmpty,
                    onTap: () => controller.setStatusFilter(''),
                  ),
                  _FilterChip(
                    label: 'Pending',
                    selected: controller.statusFilter.value == 'pending',
                    onTap: () => controller.setStatusFilter('pending'),
                  ),
                  _FilterChip(
                    label: 'Paid',
                    selected: controller.statusFilter.value == 'paid',
                    onTap: () => controller.setStatusFilter('paid'),
                  ),
                  _FilterChip(
                    label: 'Withdrawn',
                    selected: controller.statusFilter.value == 'withdraw',
                    onTap: () => controller.setStatusFilter('withdraw'),
                  ),
                ],
              )),
        ),

        // Transfer to wallet button
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.cardPadding,
            vertical: 8,
          ),
          child: Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isTransferring.value
                      ? null
                      : () => _showTransferDialog(context),
                  icon: controller.isTransferring.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.account_balance_wallet_outlined,
                          size: 18),
                  label: const Text('Transfer to Wallet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.pricePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusMd),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )),
        ),

        // Payments list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.payments.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }

            if (controller.payments.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No payments yet',
                subtitle: 'Payment records will appear here',
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchPayments(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.payments.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.payments.length) {
                    controller.fetchPayments(loadMore: true);
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: MarketplaceDesignTokens.pricePrimary,
                        strokeWidth: 2,
                      )),
                    );
                  }
                  return _PaymentCard(payment: controller.payments[index]);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showTransferDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transfer to Wallet'),
        content: TextField(
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount (€)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              Navigator.pop(ctx);
              controller.transferToWallet(amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MarketplaceDesignTokens.pricePrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor:
            MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.textSecondary(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        side: BorderSide(
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.cardBorder(context),
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Map<String, dynamic> payment;
  const _PaymentCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    final amount = payment['amount'] ?? payment['disburse_amount'] ?? 0;
    final paymentStatus = payment['payment_status'] as String? ?? 'pending';
    final productName = payment['product_name'] as String? ?? '';
    final media = payment['media'] as List? ?? [];
    final imageUrl = media.isNotEmpty ? media.first.toString() : '';

    return Container(
      margin:
          const EdgeInsets.only(bottom: MarketplaceDesignTokens.gridSpacing),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          // Product thumbnail
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: MarketplaceDesignTokens.bodyTextSmall(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                StatusBadge(
                  status: paymentStatus,
                  color: _paymentColor(paymentStatus),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            CurrencyHelper.formatPrice(amount),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: MarketplaceDesignTokens.pricePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.receipt_outlined, color: Colors.grey, size: 20),
    );
  }

  String _paymentLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'paid':
        return 'Paid';
      case 'qphold':
        return 'On Hold';
      case 'withdraw':
        return 'Withdrawn';
      default:
        return status;
    }
  }

  Color _paymentColor(String status) {
    switch (status) {
      case 'pending':
        return MarketplaceDesignTokens.orderPending;
      case 'paid':
        return MarketplaceDesignTokens.inStock;
      case 'qphold':
        return MarketplaceDesignTokens.orderProcessing;
      case 'withdraw':
        return MarketplaceDesignTokens.pricePrimary;
      default:
        return MarketplaceDesignTokens.orderPending;
    }
  }
}
