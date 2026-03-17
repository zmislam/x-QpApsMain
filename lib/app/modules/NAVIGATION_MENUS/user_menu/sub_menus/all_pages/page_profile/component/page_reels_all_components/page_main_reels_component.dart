import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../config/constants/feed_design_tokens.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/component/page_reels_all_components/page_shared_reels_components.dart'
    show PagePersonalSharedReelComponent;

import '../../controllers/page_profile_controller.dart';
import 'page_personal_reels_component.dart';

/// Facebook-style Reels tab with pill-chip sub-tabs
class PageProfileReelsComponent extends StatelessWidget {
  const PageProfileReelsComponent({super.key, required this.controller});

  final PageProfileController controller;

  @override
  Widget build(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final brand = FeedDesignTokens.brand(context);
    final dividerColor = FeedDesignTokens.divider(context);

    final List<String> subTabLabels = [
      'Personal Reels'.tr,
      'Repost Reels'.tr,
    ];

    final List<Widget> widgetList = [
      PagePersonalReelComponent(controller: controller),
      PagePersonalSharedReelComponent(controller: controller),
    ];

    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Reels'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),

          // ─── Pill-chip sub-tabs ──────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: subTabLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected =
                      controller.viewReelsTabNumber.value == index;
                  return GestureDetector(
                    onTap: () {
                      controller.viewReelsTabNumber.value = index;
                      if (index == 1) {
                        controller.getOtherRepostVideo(
                          pageUserName: controller.pageProfileModel.value
                                  ?.pageDetails?.pageUserName ??
                              '',
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? brand : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(color: dividerColor, width: 1),
                      ),
                      child: Text(
                        subTabLabels[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : textSecondary,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // ─── Content ──────────────────────────────────
          Obx(() => widgetList[controller.viewReelsTabNumber.value]),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
