import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../routes/app_pages.dart';

class OtherPersonalReelComponent extends StatelessWidget {
  const OtherPersonalReelComponent({super.key, required this.controller});
  final OthersProfileController controller;

  @override
  Widget build(BuildContext context) {
    final textSecondary = FeedDesignTokens.textSecondary(context);

    controller.getUserReels(controller.username ?? '');
    return Obx(() {
      if (controller.isLoadingUserReels.value) {
        return _shimmerLoadingView(context);
      } else if (controller.reelsList.value.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'No personal reels'.tr,
              style: TextStyle(
                fontSize: 15,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else {
        return Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.reelsList.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                final reel = controller.reelsList.value[index];
                return _buildReelItem(context, reel, index);
              },
            ),
            if (controller.hasMoreReels.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.getUserReels(controller.username ?? '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FeedDesignTokens.inputBg(context),
                      foregroundColor: FeedDesignTokens.textPrimary(context),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Show More'.tr,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
          ],
        );
      }
    });
  }

  Widget _buildReelItem(BuildContext context, dynamic reel, int index) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () {
          Get.toNamed(
            Routes.OTHER_USER_VIDEO,
            arguments: {
              'reelsID': controller.reelsList.value[index].id,
              'username': controller.username,
            },
          );
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage(
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppAssets.DEFAULT_IMAGE,
                  fit: BoxFit.cover,
                );
              },
              fit: BoxFit.cover,
              image: NetworkImage(
                ('${reel.video_thumbnail}').formatedProfileReelUrl,
              ),
              placeholder:
                  const AssetImage('assets/image/default_image.png'),
            ),
            // Gradient overlay at bottom
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
            Positioned(
              bottom: 6,
              left: 8,
              right: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reel.description != null &&
                      reel.description.isNotEmpty)
                    Text(
                      '${reel.description}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${reel.viewCount ?? 0}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerLoadingView(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, index) {
        return ShimmerLoader(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FeedDesignTokens.inputBg(context),
            ),
          ),
        );
      },
    );
  }
}
