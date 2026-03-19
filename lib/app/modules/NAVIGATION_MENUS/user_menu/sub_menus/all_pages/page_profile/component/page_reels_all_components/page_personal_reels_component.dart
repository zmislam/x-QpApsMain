import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../components/button.dart';
import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../routes/app_pages.dart';
import '../../controllers/page_profile_controller.dart';

/// Facebook-style personal reels grid with gradient overlay and view count
class PagePersonalReelComponent extends StatelessWidget {
  const PagePersonalReelComponent({super.key, required this.controller});
  final PageProfileController controller;

  @override
  Widget build(BuildContext context) {
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final brand = FeedDesignTokens.brand(context);

    controller.getPageUserReels(pageUserName: controller.pageUserName ?? '');

    return Obx(() {
      if (controller.isLoadingUserReels.value) {
        return _buildShimmerGrid();
      }

      if (controller.reelsList.value.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.videocam_off_outlined,
                    size: 48, color: textSecondary),
                const SizedBox(height: 12),
                Text(
                  'No personal reels'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: controller.reelsList.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.56,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              final reel = controller.reelsList.value[index];
              return _buildReelTile(context, reel, index);
            },
          ),
          if (controller.hasMoreReels.value == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    controller.getPageUserReels(
                      pageUserName: controller.pageProfileModel.value
                              ?.pageDetails?.pageUserName ??
                          '',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: brand),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Show More'.tr,
                    style: TextStyle(
                      color: brand,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildReelTile(BuildContext context, dynamic reel, int index) {
    final thumbnailUrl = ('${reel.video_thumbnail}').formatedProfileReelUrl;
    final pageDetails = controller.pageProfileModel.value?.pageDetails;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.USER_REELS,
          arguments: {
            'userId': pageDetails?.id ?? '',
            'username': pageDetails?.pageUserName ?? controller.pageUserName ?? '',
            'userFullName': pageDetails?.pageName ?? '',
            'userProfilePic': pageDetails?.profilePic ?? '',
            'startIndex': index,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                AppAssets.DEFAULT_IMAGE,
                fit: BoxFit.cover,
              ),
            ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // View count
            Positioned(
              bottom: 6,
              left: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    _formatCount(reel.viewCount ?? 0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.56,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return ShimmerLoader(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
        );
      },
    );
  }
}
