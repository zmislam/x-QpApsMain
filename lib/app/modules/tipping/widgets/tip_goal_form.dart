import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/tipping_controller.dart';

/// Set/edit tip goal form — bottom sheet.
class TipGoalForm extends StatefulWidget {
  final String? existingId;
  final String? existingTitle;
  final double? existingTarget;
  final DateTime? existingDeadline;

  const TipGoalForm({
    super.key,
    this.existingId,
    this.existingTitle,
    this.existingTarget,
    this.existingDeadline,
  });

  static void show(BuildContext context,
      {String? id, String? title, double? target, DateTime? deadline}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TipGoalForm(
        existingId: id,
        existingTitle: title,
        existingTarget: target,
        existingDeadline: deadline,
      ),
    );
  }

  @override
  State<TipGoalForm> createState() => _TipGoalFormState();
}

class _TipGoalFormState extends State<TipGoalForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;
  DateTime? _deadline;
  bool _isSaving = false;

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty &&
      (double.tryParse(_targetController.text) ?? 0) > 0 &&
      !_isSaving;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingTitle ?? '');
    _targetController = TextEditingController(
        text: widget.existingTarget?.toStringAsFixed(0) ?? '');
    _deadline = widget.existingDeadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _isSaving = true);

    final controller = Get.find<TippingController>();
    final success = await controller.saveGoal(
      id: widget.existingId,
      title: _titleController.text.trim(),
      targetAmount: double.parse(_targetController.text),
      deadline: _deadline,
    );

    setState(() => _isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar('Goal Saved', 'Your tip goal has been saved.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800);
    } else {
      Get.snackbar('Error', 'Failed to save goal.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade800);
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.existingId != null ? 'Edit Goal' : 'New Tip Goal',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g. New equipment',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Target Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDeadline,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _deadline != null
                      ? 'Deadline: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                      : 'Set Deadline (optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: _deadline != null
                        ? Colors.black87
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Save Goal',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
