import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/button.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../routes/app_pages.dart';

class OtherPersonalReelComponent extends StatelessWidget {
  const OtherPersonalReelComponent({super.key, required this.controller});
  final OthersProfileController controller;
  // final List<dynamic> reelsList;
  // final bool isLoading;
  // final Function(dynamic reel) onReelTap;

  @override
  Widget build(BuildContext context) {
    controller.getUserReels(controller.username ?? '');
    return Obx(() {
      if (controller.isLoadingUserReels.value) {
        return ShimmarLoadingView();
      } else if (controller.reelsList.value.isEmpty) {
        return Center(
          child: Text('User has no personal reels'.tr,
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
              itemCount: controller.reelsList.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                final reel = controller.reelsList.value[index];
                return buildReelItem(context, reel, index);
              },
            ),
            controller.hasMoreReels.value == true
                ? PrimaryButton(
                    onPressed: () {
                      controller.getUserReels(controller.username ?? '');
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
            Routes.OTHER_USER_VIDEO,
            arguments: {
              'reelsID': controller.reelsList.value[index].id,
              'username': controller.username,
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
            bottom: 5,
            left: 10,
            child: SizedBox(
              width: 60,
              child: Column(
                children: [
                  Text(
                    '${reel.description ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.visibility, color: Colors.white),
                      const SizedBox(width: 5),
                      Text('${reel.viewCount ?? 0}'.tr,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
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
