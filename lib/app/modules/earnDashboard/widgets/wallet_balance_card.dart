import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';
import 'withdrawal_history_bottom_sheet.dart';

const double _kMinWithdrawalDollars = 50.0;

class WalletBalanceCard extends GetView<EarnDashboardController> {
  const WalletBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isWalletLoading.value &&
          controller.walletSummary.value == null) {
        return _buildShimmer();
      }
      final wallet = controller.walletSummary.value;
      final walletBalance =
          controller.dailyEarningsSummary.value?.totalEarned ?? 0.0;

      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1F2937), Color(0xFF111827)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.wallet, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text('Earning Wallet',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),

            // Balance label
            Text('Total earnings available for withdraw',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6))),
            const SizedBox(height: 6),
            Text(
              '\$${walletBalance.toStringAsFixed(4)}',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text('Min. withdrawal: \$$_kMinWithdrawalDollars',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.45))),
            const SizedBox(height: 14),

            // Pending withdrawal
            if (wallet != null && wallet.pendingWithdrawalsCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Processing',
                          style:
                              TextStyle(fontSize: 13, color: Colors.white)),
                    ),
                    Text('\$${wallet.pendingWithdrawalsDollars}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),

            // Action buttons
            Row(
              children: [
                Expanded(child: _buildPrimaryButton(wallet, walletBalance)),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSecondaryButton(context, wallet),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPrimaryButton(WalletSummaryModel? wallet, double walletBalance) {
    String label;
    VoidCallback? onTap;
    Color bgColor;

    if (wallet == null) {
      label = 'Loading...';
      onTap = null;
      bgColor = Colors.grey;
    } else if (!wallet.hasStripeAccount) {
      label = 'Connect Stripe';
      onTap = controller.connectStripe;
      bgColor = Colors.blue;
    } else if (!wallet.isStripeActive) {
      label = 'Complete Verification';
      onTap = controller.connectStripe;
      bgColor = Colors.amber.shade700;
    } else if (!wallet.canWithdraw) {
      label = 'Need \$$_kMinWithdrawalDollars';
      onTap = null;
      bgColor = Colors.grey.shade600;
    } else if (!wallet.isWithdrawalReady) {
      label = wallet.isInCooldown ? 'Cooldown Active' : 'Pending Withdrawal';
      onTap = null;
      bgColor = Colors.grey.shade600;
    } else {
      label = 'Withdraw';
      onTap = () => controller.requestWithdrawal(walletBalance);
      bgColor = Colors.white;
    }

    final isWithdraw = label == 'Withdraw';
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward,
                  size: 16,
                  color: isWithdraw ? Colors.black87 : Colors.white),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isWithdraw ? Colors.black87 : Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, dynamic wallet) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showWithdrawalHistoryBottomSheet(
            context, wallet?.recentWithdrawals ?? []),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text('History',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F2937), Color(0xFF111827)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.1),
        highlightColor: Colors.white.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Container(width: 100, height: 18, color: Colors.white),
            ]),
            const SizedBox(height: 20),
            Container(width: 160, height: 12, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 120, height: 32, color: Colors.white),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)))),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)))),
            ]),
          ],
        ),
      ),
    );
  }
}
