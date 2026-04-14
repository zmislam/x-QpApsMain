import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';

/// Widget for selecting daily budget and duration for a boost campaign.
class BoostBudgetSelector extends GetView<ReelsBoostController> {
  const BoostBudgetSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily budget
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Budget',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '\$${controller.dailyBudget.value.toStringAsFixed(2)}/day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: controller.dailyBudget.value,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: '\$${controller.dailyBudget.value.toStringAsFixed(0)}',
                      onChanged: (v) => controller.dailyBudget.value = v,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$1', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        Text('\$100', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                )),
            const Divider(height: 24),

            // Duration
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${controller.durationDays.value} days',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [3, 7, 14, 30].map((days) {
                        final isSelected = controller.durationDays.value == days;
                        return ChoiceChip(
                          label: Text('$days days'),
                          selected: isSelected,
                          onSelected: (_) => controller.durationDays.value = days,
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )),
            const SizedBox(height: 12),

            // Total
            Obx(() => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$${controller.totalBudget.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
