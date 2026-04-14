import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Schedule picker — future date/time picker for delayed publishing.
class SchedulePicker extends StatelessWidget {
  final RxBool isScheduled;
  final Rx<DateTime?> scheduledDate;
  final ValueChanged<DateTime> onSchedule;
  final VoidCallback onClear;

  const SchedulePicker({
    super.key,
    required this.isScheduled,
    required this.scheduledDate,
    required this.onSchedule,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isScheduled.value && scheduledDate.value != null) {
        final dt = scheduledDate.value!;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule, color: Colors.blue),
          title: const Text('Scheduled'),
          subtitle: Text(
            '${_formatDate(dt)} at ${_formatTime(dt)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _pickDateTime(context),
                icon: const Icon(Icons.edit, size: 18),
              ),
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
        );
      }
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.schedule_outlined),
        title: const Text('Schedule for later'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _pickDateTime(context),
      );
    });
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    final minDate = now.add(const Duration(minutes: 15));

    // Pick date
    final date = await showDatePicker(
      context: context,
      initialDate: scheduledDate.value ?? minDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 75)),
    );
    if (date == null || !context.mounted) return;

    // Pick time
    final time = await showTimePicker(
      context: context,
      initialTime: scheduledDate.value != null
          ? TimeOfDay.fromDateTime(scheduledDate.value!)
          : TimeOfDay.fromDateTime(minDate),
    );
    if (time == null) return;

    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      Get.snackbar('Invalid', 'Schedule time must be in the future');
      return;
    }

    onSchedule(scheduled);
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${h == 0 ? 12 : h}:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}
