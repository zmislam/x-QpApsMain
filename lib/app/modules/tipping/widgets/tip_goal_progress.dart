import 'package:flutter/material.dart';
import '../../../config/constants/color.dart';
import '../models/tipping_models.dart';

/// Tip goal progress bar widget.
class TipGoalProgress extends StatelessWidget {
  final TipGoal goal;

  const TipGoalProgress({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${(goal.progressPercent * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PRIMARY_COLOR,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progressPercent.toDouble(),
              backgroundColor: Colors.grey.shade100,
              color: PRIMARY_COLOR,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${goal.currentAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              if (goal.deadline != null)
                Text(
                  'Due: ${goal.deadline!.day}/${goal.deadline!.month}/${goal.deadline!.year}',
                  style:
                      TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
