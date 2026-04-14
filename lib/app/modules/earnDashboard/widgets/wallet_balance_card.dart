import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';
import '../services/earning_config_service.dart';
import 'withdrawal_history_bottom_sheet.dart';

const double _kMinWithdrawalDollarsDefault = 50.0;

double get _minWithdrawalDollars {
  // Could be extended when admin config adds a minPayoutDollars field
  return _kMinWithdrawalDollarsDefault;
}

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
            Text('Min. withdrawal: \$${_minWithdrawalDollars.toStringAsFixed(0)}',
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

            // === Phase 8 Enhancements ===

            // 1. Progress bar to minimum withdrawal threshold
            const SizedBox(height: 16),
            _buildThresholdProgress(walletBalance),

            // 2. Withdrawal readiness checklist
            const SizedBox(height: 14),
            _buildReadinessChecklist(wallet),

            // 3. Recent withdrawals with expandable status
            if (wallet != null && wallet.recentWithdrawals.isNotEmpty) ...[
              const SizedBox(height: 14),
              _buildRecentWithdrawals(wallet.recentWithdrawals),
            ],

            // 4. Recent daily earnings (last 5 days)
            const SizedBox(height: 14),
            _buildRecentDailyEarnings(),
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
      label = 'Need \$${_minWithdrawalDollars.toStringAsFixed(0)}';
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

  // ── Phase 8: Threshold Progress Bar ──
  Widget _buildThresholdProgress(double balance) {
    final minThreshold = _minWithdrawalDollars;
    final progress = minThreshold > 0
        ? (balance / minThreshold).clamp(0.0, 1.0)
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Withdrawal Progress',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.7))),
            Text(
              progress >= 1.0
                  ? 'Ready!'
                  : '\$${balance.toStringAsFixed(2)} / \$${minThreshold.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: progress >= 1.0
                      ? Colors.greenAccent
                      : Colors.white.withOpacity(0.6)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? Colors.greenAccent : Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  // ── Phase 8: Withdrawal Readiness Checklist ──
  Widget _buildReadinessChecklist(WalletSummaryModel? wallet) {
    final balance =
        controller.dailyEarningsSummary.value?.totalEarned ?? 0.0;
    final minThreshold = _minWithdrawalDollars;

    final items = <_CheckItem>[
      _CheckItem(
        'Balance ≥ \$${minThreshold.toStringAsFixed(0)}',
        balance >= minThreshold,
      ),
      _CheckItem(
        'Stripe account connected',
        wallet?.hasStripeAccount ?? false,
      ),
      _CheckItem(
        'Identity verified',
        wallet?.isStripeActive ?? false,
      ),
      _CheckItem(
        'No pending withdrawal',
        (wallet?.pendingWithdrawalsCount ?? 0) == 0,
      ),
      _CheckItem(
        '24hr cooldown passed',
        !(wallet?.isInCooldown ?? true),
      ),
    ];

    final passCount = items.where((i) => i.passed).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist,
                  size: 16, color: Colors.white.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text('Readiness ($passCount/${items.length})',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7))),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      item.passed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 14,
                      color: item.passed
                          ? Colors.greenAccent
                          : Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(width: 8),
                    Text(item.label,
                        style: TextStyle(
                            fontSize: 12,
                            color: item.passed
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Phase 8: Recent Withdrawals ──
  Widget _buildRecentWithdrawals(List<WithdrawalEntry> withdrawals) {
    final recent = withdrawals.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Withdrawals',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 8),
          ...recent.map((w) {
            Color statusColor;
            IconData statusIcon;
            switch (w.status.toLowerCase()) {
              case 'completed':
                statusColor = Colors.greenAccent;
                statusIcon = Icons.check_circle;
                break;
              case 'failed':
                statusColor = Colors.redAccent;
                statusIcon = Icons.cancel;
                break;
              case 'processing':
                statusColor = Colors.blueAccent;
                statusIcon = Icons.sync;
                break;
              default: // pending
                statusColor = Colors.amber;
                statusIcon = Icons.access_time;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '\$${w.amountDollars.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    w.status.isNotEmpty
                        ? w.status[0].toUpperCase() + w.status.substring(1)
                        : '',
                    style: TextStyle(fontSize: 11, color: statusColor),
                  ),
                  if (w.requestedAt.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(w.requestedAt),
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.4)),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Phase 8: Recent Daily Earnings (last 5 days) ──
  Widget _buildRecentDailyEarnings() {
    final earnings = controller.dailyEarnings.take(5).toList();
    if (earnings.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last 5 Days',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 8),
          ...earnings.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(e.date),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    Text(
                      '+\$${e.amount.toStringAsFixed(4)}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.greenAccent),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
    }
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

class _CheckItem {
  final String label;
  final bool passed;
  const _CheckItem(this.label, this.passed);
}
