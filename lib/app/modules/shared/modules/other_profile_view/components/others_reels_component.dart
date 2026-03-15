import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../components/simmar_loader.dart';
import 'other_personal_reels_compoent.dart';
import 'other_personal_shared_reels_compoent.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../config/constants/color.dart';

class OthersProfileReelsComponent extends StatelessWidget {
  const OthersProfileReelsComponent({super.key, required this.controller});

  final OthersProfileController controller;
  @override
  Widget build(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);

    List<Widget> widgetList = [
      OtherPersonalReelComponent(controller: controller),
      OtherPersonalSharedReelComponent(controller: controller)
    ];
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: [
          // Sub-tab chips for reels
          Row(
            children: [
              _buildReelSubTab(
                context: context,
                label:
                    '${controller.profileModel.value?.first_name ?? 'User'}\'s Reels',
                isSelected: controller.viewReelsTabNumber.value == 0,
                onTap: () {
                  controller.viewReelsTabNumber.value = 0;
                },
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              const SizedBox(width: 8),
              _buildReelSubTab(
                context: context,
                label:
                    '${controller.profileModel.value?.first_name?.toString().split(' ')[0] ?? 'User'}\'s Reposts',
                isSelected: controller.viewReelsTabNumber.value == 1,
                onTap: () {
                  controller.viewReelsTabNumber.value = 1;
                  controller.getOtherRepostVideo();
                },
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => widgetList[controller.viewReelsTabNumber.value]),
        ],
      ),
    );
  }

  Widget _buildReelSubTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Obx(() => GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: (controller.viewReelsTabNumber.value == 0 && label.contains('Reels')) ||
                      (controller.viewReelsTabNumber.value == 1 && label.contains('Reposts'))
                  ? PRIMARY_COLOR
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: (controller.viewReelsTabNumber.value == 0 && label.contains('Reels')) ||
                      (controller.viewReelsTabNumber.value == 1 && label.contains('Reposts'))
                  ? null
                  : Border.all(color: FeedDesignTokens.divider(context)),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : textSecondary,
              ),
            ),
          ),
        ));
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
          physics: const ScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.7),
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width / 3,
                    height: 157,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.9)),
                  )),
            );
          }),
    );
  }
}
