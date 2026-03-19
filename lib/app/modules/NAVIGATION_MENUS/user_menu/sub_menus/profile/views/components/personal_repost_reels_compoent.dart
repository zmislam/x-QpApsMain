import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../controllers/profile_controller.dart';

class PersonalRepostReelComponent extends StatelessWidget {
  const PersonalRepostReelComponent({super.key, required this.controller});

  final ProfileController controller;

  // final List<dynamic> reelsList;
  // final bool isLoading;
  // final Function(dynamic reel) onReelTap;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingUserRepost.value) {
        return ShimmarLoadingView();
      } else if (controller.repostList.value.isEmpty) {
        return Center(
          child: Text('You have no repost reels'.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        return Column(
          children: [
            GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.repostList.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                final reel = controller.repostList.value[index];
                return buildReelItem(context, reel, index);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            controller.hasMoreRepostedReels.value
                ? PrimaryButton(
                    onPressed: () {
                      controller.getRepostVideo();
                    },
                    text: 'Show More'.tr,
                    fontSize: 12,
                    verticalPadding: 10,
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }
    });
  }

  Widget buildReelItem(BuildContext context, dynamic reel, int index) {
    return InkWell(
      onTap: () {
        Future.delayed(Duration.zero, () {
          Get.toNamed(
            Routes.USER_REELS,
            arguments: {
              'userId': controller.userModel.id ?? '',
              'username': controller.userModel.username ?? '',
              'userFullName': '${controller.userModel.first_name ?? ''} ${controller.userModel.last_name ?? ''}'.trim(),
              'userProfilePic': controller.userModel.profile_pic ?? '',
              'startIndex': index,
              'reelType': 'repost',
            },
          );
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
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // Use shape for a perfect circle
                color: Colors.white,
              ),
              child: Center(
                child: PopupMenuButton(
                    color: Colors.white,
                    offset: const Offset(-50, 60),
                    iconColor: Colors.black,
                    icon: const Icon(
                      Icons.more_vert,
                      size: 15,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () async {
                              showDeleteAlertDialogs(
                                context: context,
                                deletingItemType: 'Reel',
                                onDelete: () {
                                  controller.deleteRepostReels(reel.id ?? '');
                                  Get.back();
                                },
                                onCancel: () {
                                  Get.back();
                                },
                              );
                            },
                            value: 1,
                            child: Text('Delete'.tr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ]),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: SizedBox(
              width: 60,
              child: Column(
                children: [
                  Text(
                    '${reel.description ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.visibility, color: Colors.white),
                      const SizedBox(width: 5),
                      Text('${controller.repostList.value[index].viewCount ?? 0}'.tr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
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
      height: Get.height,
      child: GridView.builder(
        physics: const ScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width / 3,
                height: 157,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withValues(alpha: 0.9),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
