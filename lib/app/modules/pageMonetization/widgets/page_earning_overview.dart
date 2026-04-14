import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import 'page_tier_badge.dart';

/// Page earning overview for monetized pages
class PageEarningOverview extends GetView<PageMonetizationController> {
  const PageEarningOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tier = controller.tierInfo.value;
      final status = controller.monetizationStatus.value;
      final risk = controller.riskProfile.value;
      final viralCount = controller.viralContent.where((v) => v.status != 'expired').length;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Earning Overview',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                _statusDot(status?.status, risk?.earningsFrozen ?? false),
              ],
            ),
            const SizedBox(height: 14),

            // Tier and multiplier
            if (tier != null) ...[
              Row(
                children: [
                  PageTierBadge(
                    tierName: tier.tierName,
                    multiplier: tier.multiplier,
                    size: 'medium',
                  ),
                  const SizedBox(width: 12),
                  Text('Priority Score: ${tier.priorityScore}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Stats row
            Row(
              children: [
                _statTile('Viral Posts', '$viralCount',
                    icon: Icons.whatshot, color: Colors.orange),
                const SizedBox(width: 12),
                _statTile(
                  'Status',
                  (risk?.earningsFrozen ?? false)
                      ? 'Frozen'
                      : 'Active',
                  icon: (risk?.earningsFrozen ?? false)
                      ? Icons.ac_unit
                      : Icons.check_circle,
                  color: (risk?.earningsFrozen ?? false)
                      ? Colors.red
                      : Colors.green,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _statusDot(String? status, bool frozen) {
    Color color;
    if (frozen) {
      color = Colors.red;
    } else if (status == 'approved' || status == 'active') {
      color = Colors.green;
    } else {
      color = Colors.grey;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _statTile(String label, String value,
      {required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color)),
                Text(label,
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
