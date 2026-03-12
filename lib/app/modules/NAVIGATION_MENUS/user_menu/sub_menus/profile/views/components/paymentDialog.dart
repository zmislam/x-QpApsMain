import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text('Stripe Payment'.tr,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text('Proceed to pay securely using Stripe.'.tr,
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);

            // Show success popup/snackbar
            Get.snackbar(
              '',
              '',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white,
              margin: const EdgeInsets.all(12),
              borderRadius: 12,
              duration: const Duration(seconds: 2),
              titleText: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 8),
                  Text('Congratulations!'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              messageText:  Center(
                child: Text('Payment done successfully 🎉'.tr,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1877F2),
            foregroundColor: Colors.white,
          ),
          child: Text('Pay \$11'.tr),
        ),
      ],
    );
  }
}
