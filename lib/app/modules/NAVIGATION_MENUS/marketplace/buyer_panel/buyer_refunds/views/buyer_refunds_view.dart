import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../components/empty_state.dart';
import '../controllers/buyer_refunds_controller.dart';
import '../widgets/refund_card.dart';

/// Paginated refund list — shown in the "Returns" tab of BuyerPanelView.
class BuyerRefundsView extends StatelessWidget {
  const BuyerRefundsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerRefundsController>();

    return Obx(() {
      // Loading
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: MarketplaceDesignTokens.primary,
          ),
        );
      }

      // Empty
      if (controller.refunds.isEmpty) {
        return MarketplaceEmptyState(
          icon: Icons.replay_outlined,
          title: 'No Refund Requests',
          subtitle: 'You haven\'t submitted any refund requests yet.',
          actionLabel: 'Refresh',
          onAction: () => controller.fetchRefunds(refresh: true),
        );
      }

      // List
      return RefreshIndicator(
        onRefresh: () => controller.fetchRefunds(refresh: true),
        color: MarketplaceDesignTokens.primary,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.extentAfter < 200) {
              controller.loadMoreRefunds();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(
                MarketplaceDesignTokens.spacingMd),
            itemCount: controller.refunds.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading more indicator
              if (index == controller.refunds.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: MarketplaceDesignTokens.primary,
                    ),
                  ),
                );
              }

              final refund = controller.refunds[index];
              return RefundCard(
                refund: refund,
                onTap: () => Get.toNamed(
                  Routes.MARKETPLACE_REFUND_DETAIL,
                  arguments: {'refundId': refund.id},
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
