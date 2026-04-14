import 'package:flutter/material.dart';
import '../models/viral_content_models.dart' as models;

/// Score breakdown bottom sheet — shows how viral score is computed.
/// All factor labels, weights from API — NEVER hardcoded.
class ViralScoreBreakdownWidget extends StatelessWidget {
  final models.ViralScoreBreakdown data;

  const ViralScoreBreakdownWidget({super.key, required this.data});

  static void show(BuildContext context, models.ViralScoreBreakdown data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ViralScoreBreakdownSheet(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViralScoreBreakdownSheet(data: data);
  }
}

class ViralScoreBreakdownSheet extends StatelessWidget {
  final models.ViralScoreBreakdown data;

  const ViralScoreBreakdownSheet({super.key, required this.data});

  Color _tierColor(String key) {
    switch (key) {
      case 'rising':
        return Colors.orange;
      case 'viral':
        return Colors.red;
      case 'mega_viral':
        return Colors.purple;
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
        maxHeight: MediaQuery.of(context).size.height * 0.65,
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
                Text('Viral Score',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _tierColor(data.tierKey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.tierLabel,
                    style: TextStyle(
                      color: _tierColor(data.tierKey),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  data.totalScore.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _tierColor(data.tierKey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Multiplier: ${data.multiplier}x',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // Factors list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: data.factors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final f = data.factors[i];
                return _factorRow(f);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _factorRow(models.ScoreFactor factor) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(factor.label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                factor.value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                '×${factor.weight}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 50,
          child: Text(
            factor.weighted.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
