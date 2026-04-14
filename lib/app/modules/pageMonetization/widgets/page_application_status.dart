import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';

/// Application status timeline card
class PageApplicationStatus extends GetView<PageMonetizationController> {
  const PageApplicationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.monetizationStatus.value;
      if (status == null) return const SizedBox.shrink();

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
            const Row(
              children: [
                Icon(Icons.timeline, size: 20, color: PRIMARY_COLOR),
                SizedBox(width: 8),
                Text('Application Status',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),

            // Status badge
            _statusBadge(status.status),
            const SizedBox(height: 14),

            // Timeline
            _timelineStep('Submitted', status.submittedAt, _isReached(status.status, 0)),
            _timelineStep('Under Review', null, _isReached(status.status, 1)),
            _timelineStep('Decision', status.reviewedAt, _isReached(status.status, 2)),

            // Review note for rejected
            if (status.status == 'rejected' &&
                status.reviewNote != null &&
                status.reviewNote!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 14, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(status.reviewNote!,
                          style: TextStyle(
                              fontSize: 12, color: Colors.red.shade700)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  bool _isReached(String status, int step) {
    const steps = ['pending', 'under_review', 'approved'];
    const stepAlt = ['pending', 'under_review', 'rejected'];
    final idx1 = steps.indexOf(status);
    final idx2 = stepAlt.indexOf(status);
    final idx = idx1 >= 0 ? idx1 : idx2;
    return idx >= step;
  }

  Widget _statusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'under_review':
        color = Colors.blue;
        label = 'Under Review';
        break;
      case 'approved':
        color = Colors.green;
        label = 'Approved';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      case 'suspended':
        color = Colors.red.shade700;
        label = 'Suspended';
        break;
      default:
        color = Colors.grey;
        label = status.capitalizeFirst ?? status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _timelineStep(String label, DateTime? date, bool reached) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reached
                  ? PRIMARY_COLOR
                  : Colors.grey.shade200,
            ),
            child: reached
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: reached ? Colors.black87 : Colors.grey.shade400)),
          ),
          if (date != null)
            Text(DateFormat('MMM d, yyyy').format(date),
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
