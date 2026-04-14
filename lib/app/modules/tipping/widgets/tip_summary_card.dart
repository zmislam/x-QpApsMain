import 'package:flutter/material.dart';
import '../models/tipping_models.dart';

/// Overview card for tip dashboard — total received, sent, supporters.
class TipSummaryCard extends StatelessWidget {
  final TipSummary summary;

  const TipSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tip Overview',
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: [
              _statBox(
                'Received',
                '\$${summary.totalReceived.toStringAsFixed(2)}',
                Colors.green,
                Icons.call_received,
              ),
              const SizedBox(width: 12),
              _statBox(
                'Sent',
                '\$${summary.totalSent.toStringAsFixed(2)}',
                Colors.blue,
                Icons.call_made,
              ),
              const SizedBox(width: 12),
              _statBox(
                'Supporters',
                '${summary.supportersCount}',
                Colors.purple,
                Icons.people_outline,
              ),
            ],
          ),
          if (summary.topSupporter != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.emoji_events,
                    size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 6),
                Text('Top Supporter: ',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
                Text(
                  summary.topSupporter!.userName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '\$${summary.topSupporter!.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBox(
      String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
