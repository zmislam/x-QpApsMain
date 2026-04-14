import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../models/page_monetization_models.dart';

/// Eligibility criteria checklist card
class PageEligibilityCard extends GetView<PageMonetizationController> {
  const PageEligibilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final elig = controller.eligibility.value;
      if (elig == null) return const SizedBox.shrink();

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
                Icon(
                  elig.isEligible
                      ? Icons.check_circle
                      : Icons.hourglass_empty,
                  color: elig.isEligible ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  elig.isEligible ? 'Eligible!' : 'Eligibility Progress',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            if (elig.message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(elig.message,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600)),
            ],
            const SizedBox(height: 12),
            ...elig.criteria.map(_criteriaRow),
          ],
        ),
      );
    });
  }

  Widget _criteriaRow(EligibilityCriteria c) {
    final met = c.met;
    final current = c.current;
    final required = c.required_;
    double? progress;

    if (current is num && required is num && required > 0) {
      progress = (current / required).clamp(0.0, 1.0).toDouble();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                met ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: met ? Colors.green : Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _criteriaLabel(c.name),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: met ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
              ),
              Text(
                '$current / $required',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: met ? Colors.green : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          if (!met && progress != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.grey.shade100,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _criteriaLabel(String name) {
    switch (name) {
      case 'followers':
        return 'Followers';
      case 'monthly_views':
        return 'Monthly Views';
      case 'account_age':
        return 'Page Age (days)';
      case 'total_posts':
        return 'Total Posts';
      case 'engagement_rate':
        return 'Engagement Rate (%)';
      default:
        return name.replaceAll('_', ' ').capitalizeFirst ?? name;
    }
  }
}
