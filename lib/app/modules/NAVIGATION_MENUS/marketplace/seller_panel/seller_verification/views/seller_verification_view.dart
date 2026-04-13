import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/seller_verification_controller.dart';

/// Seller verification: shows status or form to submit.
class SellerVerificationView extends GetView<SellerVerificationController> {
  const SellerVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }

      final data = controller.verificationData.value;
      final status = controller.status;

      // If approved — show success
      if (status == 'approved') return _ApprovedView();

      // If pending or under_review — show status card
      if (status == 'pending' || status == 'under_review') {
        return _PendingView(status: status, data: data!);
      }

      // If rejected — show reason + re-submit
      if (status == 'rejected') {
        return _RejectedView(
          reason: controller.rejectionReason,
          data: data!,
          onResubmit: () => _showForm(context, prefill: data),
        );
      }

      // Not submitted — show form or prompt
      if (controller.stores.isEmpty) {
        return MarketplaceEmptyState(
          icon: Icons.store_outlined,
          title: 'No stores found',
          subtitle: 'Create a store first to submit verification',
        );
      }

      return _NotSubmittedView(
        onSubmit: () => _showForm(context),
      );
    });
  }

  void _showForm(BuildContext context, {Map<String, dynamic>? prefill}) {
    final nameCtrl = TextEditingController(
        text: prefill?['business_name']?.toString() ?? '');
    final taxIdCtrl =
        TextEditingController(text: prefill?['tax_id']?.toString() ?? '');
    final bankNameCtrl = TextEditingController(
        text: prefill?['bank_name']?.toString() ?? '');
    final bankAccountCtrl = TextEditingController(
        text: prefill?['bank_account']?.toString() ?? '');
    final bankRoutingCtrl = TextEditingController(
        text: prefill?['bank_routing']?.toString() ?? '');

    String businessType =
        prefill?['business_type']?.toString() ?? 'individual';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.cardBg(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(MarketplaceDesignTokens.radiusLg),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.spacingMd,
                    vertical: MarketplaceDesignTokens.spacingSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Seller Verification',
                        style:
                            MarketplaceDesignTokens.sectionTitle(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    children: [
                      // Store selector
                      _Label('Store'),
                      const SizedBox(height: 6),
                      Obx(() => Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      MarketplaceDesignTokens.cardBorder(
                                          context)),
                              borderRadius: BorderRadius.circular(
                                  MarketplaceDesignTokens.radiusMd),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller
                                        .selectedStoreId.value.isEmpty
                                    ? null
                                    : controller.selectedStoreId.value,
                                isExpanded: true,
                                hint: const Text('Select store'),
                                items: controller.stores.map((s) {
                                  return DropdownMenuItem(
                                    value: s['_id']?.toString() ?? '',
                                    child: Text(
                                      s['store_name']?.toString() ??
                                          'Store',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    final store =
                                        controller.stores.firstWhere(
                                            (s) =>
                                                s['_id']?.toString() ==
                                                val);
                                    controller.selectStore(
                                        val,
                                        store['store_name']?.toString() ??
                                            'Store');
                                  }
                                },
                              ),
                            ),
                          )),
                      const SizedBox(height: 14),

                      // Business name
                      _Label('Business Name *'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration:
                            _inputDec(context, 'Your business name'),
                      ),
                      const SizedBox(height: 14),

                      // Business type
                      _Label('Business Type *'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _TypeChip(
                            label: 'Individual',
                            selected: businessType == 'individual',
                            onTap: () =>
                                setState(() => businessType = 'individual'),
                          ),
                          const SizedBox(width: 8),
                          _TypeChip(
                            label: 'Company',
                            selected: businessType == 'company',
                            onTap: () =>
                                setState(() => businessType = 'company'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tax ID
                      _Label('Tax ID (optional)'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: taxIdCtrl,
                        decoration:
                            _inputDec(context, 'e.g. VAT123456'),
                      ),
                      const SizedBox(height: 20),

                      // Bank Info section
                      Text(
                        'Bank Information',
                        style:
                            MarketplaceDesignTokens.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),

                      _Label('Bank Name'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: bankNameCtrl,
                        decoration:
                            _inputDec(context, 'e.g. Deutsche Bank'),
                      ),
                      const SizedBox(height: 14),

                      _Label('Account Number / IBAN'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: bankAccountCtrl,
                        decoration:
                            _inputDec(context, 'e.g. DE89370400044...'),
                      ),
                      const SizedBox(height: 14),

                      _Label('Routing / BIC'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: bankRoutingCtrl,
                        decoration:
                            _inputDec(context, 'e.g. COBADEFFXXX'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Submit
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    child: Obx(() => SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () async {
                                    final name = nameCtrl.text.trim();
                                    if (name.isEmpty) {
                                      Get.snackbar('Required',
                                          'Business name is required',
                                          snackPosition:
                                              SnackPosition.BOTTOM);
                                      return;
                                    }
                                    final ok =
                                        await controller.submitVerification(
                                      businessName: name,
                                      businessType: businessType,
                                      taxId: taxIdCtrl.text.trim(),
                                      bankName: bankNameCtrl.text.trim(),
                                      bankAccount:
                                          bankAccountCtrl.text.trim(),
                                      bankRouting:
                                          bankRoutingCtrl.text.trim(),
                                    );
                                    if (ok && ctx.mounted) {
                                      Navigator.pop(ctx);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  MarketplaceDesignTokens.pricePrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MarketplaceDesignTokens.radiusMd),
                              ),
                            ),
                            child: Text(
                              controller.isSubmitting.value
                                  ? 'Submitting...'
                                  : 'Submit Verification',
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        borderSide: BorderSide(
            color: MarketplaceDesignTokens.cardBorder(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        borderSide: BorderSide(
            color: MarketplaceDesignTokens.cardBorder(context)),
      ),
    );
  }
}

// ─── Status views ─────────────────────────────────────────
class _ApprovedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.inStock
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified,
                  size: 56, color: MarketplaceDesignTokens.inStock),
            ),
            const SizedBox(height: 16),
            Text(
              'Verified Seller',
              style: MarketplaceDesignTokens.heading(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Your store has been verified. Buyers will see a verified badge on your store.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingView extends StatelessWidget {
  final String status;
  final Map<String, dynamic> data;

  const _PendingView({required this.status, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hourglass_top,
                  size: 56, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            Text(
              status == 'pending'
                  ? 'Verification Pending'
                  : 'Under Review',
              style: MarketplaceDesignTokens.heading(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Your verification request has been submitted and is being reviewed by our team.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
            const SizedBox(height: 24),
            _InfoItem(label: 'Business', value: data['business_name']?.toString() ?? '—'),
            _InfoItem(label: 'Type', value: (data['business_type']?.toString() ?? '—').capitalizeFirst ?? ''),
            if ((data['tax_id']?.toString() ?? '').isNotEmpty)
              _InfoItem(label: 'Tax ID', value: data['tax_id'].toString()),
          ],
        ),
      ),
    );
  }
}

class _RejectedView extends StatelessWidget {
  final String reason;
  final Map<String, dynamic> data;
  final VoidCallback onResubmit;

  const _RejectedView({
    required this.reason,
    required this.data,
    required this.onResubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.outOfStock
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cancel_outlined,
                  size: 56, color: MarketplaceDesignTokens.outOfStock),
            ),
            const SizedBox(height: 16),
            Text(
              'Verification Rejected',
              style: MarketplaceDesignTokens.heading(context),
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.outOfStock
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                  border: Border.all(
                    color: MarketplaceDesignTokens.outOfStock
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 18,
                        color: MarketplaceDesignTokens.outOfStock),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reason,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onResubmit,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Re-submit Verification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceDesignTokens.pricePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotSubmittedView extends StatelessWidget {
  final VoidCallback onSubmit;
  const _NotSubmittedView({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.pricePrimary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user_outlined,
                  size: 56,
                  color: MarketplaceDesignTokens.pricePrimary),
            ),
            const SizedBox(height: 16),
            Text(
              'Get Verified',
              style: MarketplaceDesignTokens.heading(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Verify your seller account to build trust with buyers and unlock additional features.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.assignment_outlined, size: 18),
                label: const Text('Start Verification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceDesignTokens.pricePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: MarketplaceDesignTokens.bodyText(context)
          .copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
                  .withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
          border: Border.all(
            color: selected
                ? MarketplaceDesignTokens.pricePrimary
                : MarketplaceDesignTokens.cardBorder(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? MarketplaceDesignTokens.pricePrimary
                : MarketplaceDesignTokens.textSecondary(context),
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: MarketplaceDesignTokens.bodyText(context)
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
