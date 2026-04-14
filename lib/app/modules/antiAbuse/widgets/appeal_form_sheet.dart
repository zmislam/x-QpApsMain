import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../services/anti_abuse_api_service.dart';

/// Appeal submission bottom sheet.
/// Reason selector + explanation (min 50 chars) + submit.
/// API: POST /api/anti-abuse/appeal
class AppealFormSheet extends StatefulWidget {
  const AppealFormSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AppealFormSheet(),
    );
  }

  @override
  State<AppealFormSheet> createState() => _AppealFormSheetState();
}

class _AppealFormSheetState extends State<AppealFormSheet> {
  final _explanationController = TextEditingController();
  String? _selectedReason;
  bool _isSubmitting = false;

  final _reasons = [
    'False positive detection',
    'Content misclassified',
    'Account compromised & recovered',
    'Technical error',
    'Other',
  ];

  bool get _canSubmit =>
      _selectedReason != null &&
      _explanationController.text.trim().length >= 50 &&
      !_isSubmitting;

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _isSubmitting = true);

    final success = await AntiAbuseApiService().submitAppeal(
      reason: _selectedReason!,
      explanation: _explanationController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'Appeal Submitted',
        'Your appeal is under review.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to submit appeal. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
            const Text('Submit Appeal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            // Reason dropdown
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              items: _reasons
                  .map((r) =>
                      DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => _selectedReason = v),
            ),
            const SizedBox(height: 14),
            // Explanation
            TextField(
              controller: _explanationController,
              maxLines: 4,
              maxLength: 500,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Explanation (min 50 characters)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.all(14),
              ),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Appeal',
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
