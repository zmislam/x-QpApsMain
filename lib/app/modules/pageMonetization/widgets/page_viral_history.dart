import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../models/page_monetization_models.dart';
import '../../earnDashboard/services/earning_config_service.dart';

/// Viral content history list for a page
class PageViralHistory extends GetView<PageMonetizationController> {
  const PageViralHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.viralContent;
      if (items.isEmpty) return const SizedBox.shrink();

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
            Row(
              children: [
                const Icon(Icons.whatshot, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Viral Content',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                Text('${items.length} posts',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(_viralItem),
          ],
        ),
      );
    });
  }

  Widget _viralItem(PageViralContent v) {
    final statusInfo = _statusInfo(v.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusInfo.color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusInfo.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(statusInfo.label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusInfo.color)),
              ),
              const SizedBox(width: 8),
              Text('Score: ${v.viralScore}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${v.bonusMultiplier}x',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: statusInfo.color)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _chip(Icons.visibility_outlined, _formatCount(v.views)),
              const SizedBox(width: 10),
              _chip(Icons.share_outlined, _formatCount(v.shares)),
              const SizedBox(width: 10),
              _chip(Icons.attach_money, '+\$${v.bonusEarnings.toStringAsFixed(4)}'),
              const Spacer(),
              if (v.detectedAt != null)
                Text(DateFormat('M/d').format(v.detectedAt!),
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 2),
        Text(text,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  ({String label, Color color}) _statusInfo(String status) {
    // Dynamic labels from config when available
    final config = Get.find<EarningConfigService>();
    final thresholds = config.viralThresholds;

    switch (status) {
      case 'rising':
        final t = thresholds.isNotEmpty ? thresholds.first : null;
        return (label: t?.label ?? 'Rising', color: Colors.orange);
      case 'viral':
        final t = thresholds.length > 1 ? thresholds[1] : null;
        return (label: t?.label ?? 'Viral', color: Colors.red);
      case 'mega_viral':
        final t = thresholds.length > 2 ? thresholds[2] : null;
        return (label: t?.label ?? 'Mega Viral', color: Colors.purple);
      case 'expired':
        return (label: 'Expired', color: Colors.grey);
      default:
        return (label: status.capitalizeFirst ?? status, color: Colors.grey);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }
}
