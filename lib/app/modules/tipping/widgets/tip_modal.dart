import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/tipping_controller.dart';

/// Amount selection bottom sheet for sending tips.
class TipModal extends StatefulWidget {
  final String toUserId;
  final String toUserName;
  final String? postId;

  const TipModal({
    super.key,
    required this.toUserId,
    required this.toUserName,
    this.postId,
  });

  static void show(BuildContext context,
      {required String toUserId,
      required String toUserName,
      String? postId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TipModal(
        toUserId: toUserId,
        toUserName: toUserName,
        postId: postId,
      ),
    );
  }

  @override
  State<TipModal> createState() => _TipModalState();
}

class _TipModalState extends State<TipModal> {
  final _customController = TextEditingController();
  final _messageController = TextEditingController();
  double _selectedAmount = 0;
  bool _isSending = false;

  final _presetAmounts = [1.0, 2.0, 5.0, 10.0, 25.0, 50.0];

  bool get _canSend =>
      (_selectedAmount > 0 ||
          (double.tryParse(_customController.text) ?? 0) > 0) &&
      !_isSending;

  double get _finalAmount =>
      _selectedAmount > 0
          ? _selectedAmount
          : (double.tryParse(_customController.text) ?? 0);

  @override
  void dispose() {
    _customController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_canSend) return;
    setState(() => _isSending = true);

    final controller = Get.find<TippingController>();
    final success = await controller.sendTip(
      toUserId: widget.toUserId,
      amount: _finalAmount,
      message: _messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim(),
      postId: widget.postId,
    );

    setState(() => _isSending = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'Tip Sent! 🎉',
        '\$${_finalAmount.toStringAsFixed(2)} sent to ${widget.toUserName}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to send tip. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
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
            Text('Send Tip to ${widget.toUserName}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            // Preset amounts
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetAmounts.map((amt) {
                final selected = _selectedAmount == amt;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = selected ? 0 : amt;
                      if (!selected) _customController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? PRIMARY_COLOR
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selected
                              ? PRIMARY_COLOR
                              : Colors.grey.shade200),
                    ),
                    child: Text(
                      '\$${amt.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Custom amount
            TextField(
              controller: _customController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '\$ ',
                hintText: 'Custom amount',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (_) {
                setState(() => _selectedAmount = 0);
              },
            ),
            const SizedBox(height: 12),
            // Optional message
            TextField(
              controller: _messageController,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Add a message (optional)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            // Send button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSend ? _send : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(
                        _finalAmount > 0
                            ? 'Send \$${_finalAmount.toStringAsFixed(2)}'
                            : 'Send Tip',
                        style: const TextStyle(
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
