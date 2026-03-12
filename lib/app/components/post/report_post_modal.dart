import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

class ReportPostModal extends GetView<HomeController> {
  final String postId;

  const ReportPostModal({super.key, required this.postId});

  /// Show the report post modal as a bottom sheet.
  static void show({required BuildContext context, required String postId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportPostModal(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure reports are fetched when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getReports();
      controller.reportDescription.clear();
      controller.selectedReportId.value = '';
    });

    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(maxHeight: Get.height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Header ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Report Post'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: FeedDesignTokens.divider(context)),

          // ─── Content ───
          Expanded(
            child: Obx(() {
              if (controller.isLoadingUserPages.value) { // Reusing this loading flag from controller
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.pageReportList.value.length,
                itemBuilder: (context, index) {
                  final report = controller.pageReportList.value[index];
                  return Obx(() {
                    final isSelected = controller.selectedReportId.value == report.id;
                    return InkWell(
                      onTap: () {
                         controller.selectedReportId.value = report.id ?? '';
                         controller.selectedReportType.value = report.reportType ?? '';
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: isSelected ? PRIMARY_COLOR.withOpacity(0.05) : null,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                report.reportType ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? PRIMARY_COLOR : FeedDesignTokens.textPrimary(context),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: PRIMARY_COLOR, size: 20)
                            else
                              Icon(Icons.radio_button_unchecked, color: FeedDesignTokens.textSecondary(context), size: 20),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
          
          // ─── Description Input (Optional, shown if selected) ───
          Obx(() => controller.selectedReportId.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller.reportDescription,
                    decoration: InputDecoration(
                      hintText: 'Additional details (optional)...'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    maxLines: 3,
                  ),
                )
              : const SizedBox.shrink()),


          Divider(height: 1, color: FeedDesignTokens.divider(context)),

          // ─── Footer Actions ───
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Cancel'.tr, style: TextStyle(color: FeedDesignTokens.textPrimary(context))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.selectedReportId.value.isEmpty
                        ? null
                        : () {
                            controller.reportAPost(
                              report_type: controller.selectedReportType.value,
                              description: controller.reportDescription.text,
                              post_id: postId,
                              report_type_id: controller.selectedReportId.value,
                            );
                            Get.back(); // Close modal on submit
                            // Optional: Show success snackbar here or in controller
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Submit Report'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
