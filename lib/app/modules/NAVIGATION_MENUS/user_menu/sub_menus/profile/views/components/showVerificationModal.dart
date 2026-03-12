import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/profile_model.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/views/components/paymentDialog.dart';

import '../../controllers/profile_controller.dart';

void showVerificationModal(BuildContext context, ProfileModel user) {
  final controller = Get.find<ProfileController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext modalContext) {
      // Use Padding with viewInsets so the sheet moves above the keyboard.
      return SafeArea(
        top: false, // the sheet's top radius is already handled by shape
        child: LayoutBuilder(builder: (context, constraints) {
          // Constrain height so sheet doesn't try to fill entire screen unexpectedly.
          final maxHeight = constraints.maxHeight * 0.92;
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: SingleChildScrollView(
              // Important: allow the sheet to resize when keyboard opens.
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button (accessible tap target)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Build trust with Quantum Possibilities Verified'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Use IconButton with minimum size so it remains tappable
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(modalContext).pop(),
                        tooltip: 'Close',
                        splashRadius: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Confirm and pay'.tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'You are subscribing to Quantum Possibilities Verified. This can take up to 48 hours. If we\'re unable to confirm your identity, we\'ll refund your payment.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User profile card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user.profile_pic != null &&
                              user.profile_pic!.isNotEmpty
                              ? NetworkImage(user.profile_pic!.formatedProfileUrl)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: user.profile_pic == null ||
                              user.profile_pic!.isEmpty
                              ? Icon(Icons.person, size: 35, color: Colors.grey[600])
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.first_name ?? ''} ${user.last_name ?? ''}'
                                    .trim(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'You\'ll be billed \$11.99 per month.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // What you get section
                  Text(
                    'What you get with your subscription.'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Benefits list
                  _buildBulletPoint('Quantum Possibilities Verified badge'),
                  _buildBulletPoint('Access to exclusive features'),
                  _buildBulletPoint('More trust from your followers'),
                  _buildBulletPoint('Priority support'),
                  const SizedBox(height: 16),

                  // Terms text
                  Text(
                    'Subscribing to Quantum Possibilities Verified means you agree to our Terms and Policies. You can cancel at least 24 hours before your next payment date.'
                        .tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons — wrapped in a SafeArea to avoid bottom system UI overlap
                  SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Pay with Wallet Balance button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                'Coming Soon!',
                                'Wallet payment will be available soon',
                                colorText: Colors.black,
                                backgroundColor: Colors.white,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D7377),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Pay Wallet Balance'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Direct Payment with Stripe button (WITH Obx for loading state)
                        Expanded(
                          child: Obx(
                                () => ElevatedButton(
                              onPressed: controller.isProcessingPayment.value
                                  ? null
                                  : () async {
                                // Extra defensive check
                                if (!controller.isProcessingPayment.value) {
                                  await controller.makePayment();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1877F2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: Colors.grey[400],
                              ),
                              child: controller.isProcessingPayment.value
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text(
                                'Direct payments'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}

// Helper method for bullet points
Widget _buildBulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• '.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    ),
  );
}
