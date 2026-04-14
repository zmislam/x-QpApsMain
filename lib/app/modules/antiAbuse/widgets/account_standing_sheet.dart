import 'package:flutter/material.dart';
import '../models/anti_abuse_models.dart';

/// Bottom sheet showing detailed account standing information.
/// Risk score, flags, last scan time — all from API.
class AccountStandingSheet extends StatelessWidget {
  final AccountStanding standing;

  const AccountStandingSheet({super.key, required this.standing});

  static void show(BuildContext context, AccountStanding standing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountStandingSheet(standing: standing),
    );
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.yellow.shade700;
      case 'high':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text('Account Standing',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _levelColor(standing.riskLevel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    standing.riskLevel.toUpperCase(),
                    style: TextStyle(
                      color: _levelColor(standing.riskLevel),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Risk score bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Risk Score',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    Text('${standing.riskScore.toStringAsFixed(0)}/100',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _levelColor(standing.riskLevel))),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: standing.riskScore / 100,
                    backgroundColor: Colors.grey.shade100,
                    color: _levelColor(standing.riskLevel),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // Flags
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (standing.flags.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('No active flags',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500)),
                    ),
                  )
                else ...[
                  Text('Active Flags',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...standing.flags.map((f) => _flagItem(f)),
                ],
                if (standing.activeAppeal != null) ...[
                  const SizedBox(height: 20),
                  Text('Active Appeal',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _appealItem(standing.activeAppeal!),
                ],
                if (standing.lastScanAt != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Last scanned: ${_formatDate(standing.lastScanAt!)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _flagItem(RiskFlag flag) {
    final sevColor = flag.severity == 'high'
        ? Colors.red
        : flag.severity == 'medium'
            ? Colors.orange
            : Colors.yellow.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: sevColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flag.type.replaceAll('_', ' '),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(flag.description,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appealItem(AppealInfo appeal) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Status: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text(appeal.status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Reason: ${appeal.reason}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          const SizedBox(height: 2),
          Text(
              'Submitted: ${_formatDate(appeal.submittedAt)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          if (appeal.resolutionNote != null) ...[
            const SizedBox(height: 4),
            Text('Note: ${appeal.resolutionNote}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}
