import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../controllers/group_profile_controller.dart';

class GroupProfileWritePostComponent extends StatelessWidget {
  final GroupProfileController controller;

  const GroupProfileWritePostComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundCornerNetworkImage(
              imageUrl:
                  (controller.userModel.profile_pic ?? '').formatedProfileUrl,
            ),
            InkWell(
              onTap: controller.onTapCreatePost,
              child: Container(
                height: 40,
                width: Get.width - 140,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  maxLines: 1,
                  "  What's on your mind, ${controller.userModel.first_name}?",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
              child: InkWell(
                  onTap: () {
                    // controller.onTapCreatePost();
                    controller.pickMediaFiles();
                  },
                  child: Image.asset(
                    AppAssets.Gallery_ICON,
                    height: 35,
                    width: 35,
                  )),
            )
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 5),
        if (controller.postList.value.isNotEmpty ||
            controller.isLoadingNewsFeed.value)
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: 10,
              bottom: 5,
            ),
            child: Text('Most Recent'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

class InteractionButton extends StatelessWidget {
  final Image icon;
  final String label;

  const InteractionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          icon,
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
