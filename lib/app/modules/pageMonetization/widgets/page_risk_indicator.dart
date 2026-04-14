import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../models/page_monetization_models.dart';
import '../../earnDashboard/services/earning_config_service.dart';

/// Risk score gauge and detected signals
class PageRiskIndicator extends GetView<PageMonetizationController> {
  const PageRiskIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final risk = controller.riskProfile.value;
      if (risk == null) return const SizedBox.shrink();

      final riskColor = _riskColor(risk.riskLevel);

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
                Icon(Icons.shield_outlined, size: 20, color: riskColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Risk Profile',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                if (risk.lastScanAt != null)
                  Text('Scanned ${_timeAgo(risk.lastScanAt!)}',
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 14),

            // Risk score gauge
            _riskGauge(risk.riskScore, riskColor),
            const SizedBox(height: 8),

            // Risk level label
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${risk.riskLevel.capitalizeFirst} Risk',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: riskColor),
                ),
              ),
            ),

            // Frozen warning
            if (risk.earningsFrozen) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 18, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Earnings frozen pending review',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Signals
            if (risk.signals.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('Detected Signals',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              ...risk.signals.map(_signalItem),
            ],
          ],
        ),
      );
    });
  }

  Widget _riskGauge(int score, Color color) {
    return Column(
      children: [
        Text('$score',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.w800, color: color)),
        const Text('/100',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _signalItem(RiskSignal signal) {
    final sevColor = _severityColor(signal.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: sevColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration:
                BoxDecoration(color: sevColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(signal.type.replaceAll('_', ' ').capitalizeFirst ?? signal.type,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                if (signal.description.isNotEmpty)
                  Text(signal.description,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _severityColor(String sev) {
    switch (sev.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
