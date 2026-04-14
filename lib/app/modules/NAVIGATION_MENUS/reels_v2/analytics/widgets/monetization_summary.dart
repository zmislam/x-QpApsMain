import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';

class MonetizationSummary extends GetView<ReelsAnalyticsController> {
  const MonetizationSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.earningsData.value;

      if (data == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loadEarnings();
        });

        return Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Loading earnings...',
                style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      final totalEarnings = data['totalEarnings'] ?? 0.0;
      final adRevenue = data['adRevenue'] ?? 0.0;
      final tipsReceived = data['tipsReceived'] ?? 0.0;
      final giftRevenue = data['giftRevenue'] ?? 0.0;
      final paidSubs = data['paidSubscriptions'] ?? 0.0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total earnings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Earnings',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  '\$${_formatMoney(totalEarnings)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey, height: 1),
            const SizedBox(height: 12),

            // Breakdown
            _earningRow('Ad Revenue', adRevenue, Icons.campaign),
            _earningRow('Tips', tipsReceived, Icons.monetization_on),
            _earningRow('Gifts', giftRevenue, Icons.card_giftcard),
            _earningRow('Subscriptions', paidSubs, Icons.star),
          ],
        ),
      );
    });
  }

  Widget _earningRow(String label, dynamic amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
          Text(
            '\$${_formatMoney(amount)}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatMoney(dynamic amount) {
    final val = (amount is num) ? amount.toDouble() : 0.0;
    if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(2)}K';
    }
    return val.toStringAsFixed(2);
  }
}
