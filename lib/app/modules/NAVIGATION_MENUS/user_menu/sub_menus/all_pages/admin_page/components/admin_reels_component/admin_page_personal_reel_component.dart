import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../controller/admin_page_controller.dart';
import '../../../../../../../../routes/app_pages.dart';

/// Facebook-style personal reels grid (Admin page)
class AdminPagePersonalReelComponent extends StatelessWidget {
  const AdminPagePersonalReelComponent({super.key, required this.controller});
  final AdminPageController controller;

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = FeedDesignTokens.textSecondary(context);

    controller.getPageUserReels(pageUserName: controller.pageUserName ?? '');

    return Obx(() {
      if (controller.isLoadingUserReels.value) {
        return _buildShimmerGrid();
      }

      if (controller.reelsList.value.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No personal reels yet'.tr,
              style: TextStyle(fontSize: 15, color: textSecondary),
            ),
          ),
        );
      }

      final reels = controller.reelsList.value;
      final displayCount = reels.length > 9 ? 9 : reels.length;

      return Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.56,
            ),
            itemBuilder: (context, index) {
              final reel = reels[index];
              return _buildReelCard(context, reel, index);
            },
          ),
          if (controller.hasMoreReels == true || reels.length > displayCount)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                    side: BorderSide(
                        color: FeedDesignTokens.divider(context), width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Show More'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildReelCard(BuildContext context, dynamic reel, int index) {
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
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            FadeInImage(
              imageErrorBuilder: (_, __, ___) => Image.asset(
                AppAssets.DEFAULT_IMAGE,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
              image: NetworkImage(
                ('${reel.video_thumbnail}').formatedProfileReelUrl,
              ),
              placeholder: const AssetImage('assets/image/default_image.png'),
            ),

            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Play icon
            const Center(
              child: Icon(Icons.play_circle_outline,
                  color: Colors.white70, size: 32),
            ),

            // View count badge
            Positioned(
              bottom: 6,
              left: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 14),
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

  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (_, __) {
        return ShimmerLoader(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }
}
