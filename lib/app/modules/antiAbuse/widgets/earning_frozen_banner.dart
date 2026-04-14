import 'package:flutter/material.dart';

/// Non-dismissible red banner for frozen earnings.
/// Shows frozen amount and appeal CTA.
class EarningFrozenBanner extends StatelessWidget {
  final double? frozenAmount;
  final VoidCallback? onSubmitAppeal;

  const EarningFrozenBanner({
    super.key,
    this.frozenAmount,
    this.onSubmitAppeal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.red.shade700, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your earnings are frozen pending review',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (frozenAmount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Frozen amount: \$${frozenAmount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (onSubmitAppeal != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onSubmitAppeal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Submit Appeal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
