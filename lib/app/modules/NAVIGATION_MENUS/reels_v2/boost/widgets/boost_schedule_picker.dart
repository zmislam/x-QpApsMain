import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';

/// Widget for selecting the start date and schedule for a boost campaign.
class BoostSchedulePicker extends GetView<ReelsBoostController> {
  const BoostSchedulePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.play_circle_outline,
                      color: Theme.of(context).primaryColor),
                  title: const Text(
                    'Start Date',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _formatDate(controller.startDate.value),
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () => _pickStartDate(context),
                    child: const Text('Change', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const Divider(height: 16),

                // End date (computed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.stop_circle_outlined,
                      color: Colors.red[400]),
                  title: const Text(
                    'End Date',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    controller.endDate.value != null
                        ? _formatDate(controller.endDate.value!)
                        : 'Auto-calculated',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                  trailing: Text(
                    '${controller.durationDays.value} days',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.startDate.value,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      controller.startDate.value = picked;
      controller.endDate.value =
          picked.add(Duration(days: controller.durationDays.value));
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
