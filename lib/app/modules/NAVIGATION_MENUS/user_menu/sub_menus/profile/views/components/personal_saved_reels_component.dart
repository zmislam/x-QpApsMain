import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../controllers/profile_controller.dart';

class PersonalSavedReelComponent extends StatelessWidget {
  const PersonalSavedReelComponent({super.key, required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    controller.getSavedReels();
    return Obx(() {
      if (controller.isLoadingSavedReels.value == true &&
          controller.savedReelsList.value.isEmpty) {
        return ShimmarLoadingView();
      } else if (controller.savedReelsList.value.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark_border, color: Colors.grey.shade400, size: 48),
              const SizedBox(height: 12),
              Text(
                'No saved reels yet'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap the bookmark icon on a reel to save it'.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.savedReelsList.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                final reel = controller.savedReelsList.value[index];
                return buildReelItem(context, reel, index);
              },
            ),
            const SizedBox(height: 10),
            controller.hasMoreSavedReels.value == true
                ? PrimaryButton(
                    onPressed: () {
                      controller.getSavedReels();
                    },
                    text: 'Show More'.tr,
                    fontSize: 12,
                    verticalPadding: 10,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
          ],
        );
      }
    });
  }

  Widget buildReelItem(BuildContext context, dynamic reel, int index) {
    final userData = controller.loginCredential.getUserData();
    return InkWell(
      onTap: () {
        Future.delayed(Duration.zero, () {
          // Navigate to user-specific reels viewer (saved mode) starting at tapped index
          Get.toNamed(Routes.USER_REELS, arguments: {
            'userId': userData.id ?? '',
            'username': userData.username ?? '',
            'userFullName':
                '${userData.first_name ?? ''} ${userData.last_name ?? ''}'.trim(),
            'userProfilePic': userData.profile_pic ?? '',
            'startIndex': index,
            'reelType': 'saved',
          });
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Image(
                    height: 400,
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.DEFAULT_IMAGE),
                  );
                },
                width: Get.width / 3,
                height: 400,
                fit: BoxFit.cover,
                image: NetworkImage(
                  ('${reel.video_thumbnail}').formatedProfileReelUrl,
                ),
                placeholder: const AssetImage('assets/image/default_image.png'),
              ),
            ),
          ),
          // Bookmark badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          // View count and description
          Positioned(
            bottom: 5,
            left: 10,
            child: SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reel.description != null && reel.description!.isNotEmpty)
                    Text(
                      '${reel.description}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.visibility, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${reel.view_count ?? 0}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height * 0.5,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
