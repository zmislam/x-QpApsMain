import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/app_assets.dart';
import '../button.dart';
import '../simmar_loader.dart';

class PostShimerLoader extends StatelessWidget {
  const PostShimerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  ShimmerLoader(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color.fromARGB(255, 45, 185, 185),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width - 100,
                            ),
                            const SizedBox(height: 7),
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width / 2,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ShimmerLoader(
              child: Container(
                width: double.maxFinite,
                height: 256,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.LIKE_ICON,
                    text: 'Like'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.COMMENT_ACTION_ICON,
                    text: 'Comment'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.SHARE_ACTION_ICON,
                    text: 'Share'.tr,
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class PostShimerLoaderGeneral extends StatelessWidget {
  const PostShimerLoaderGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    // Using ListView.builder instead of SliverList.builder to remove the sliver dependency.
    // This allows the widget to be used directly within a Column or other non-sliver widgets.
    return ListView.builder(
      // shrinkWrap: true makes the ListView only occupy the space it needs,
      // which is useful when nesting it inside other scrollable widgets or Columns.
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics() prevents the ListView itself from scrolling,
      // which is typically desired for a loader that is part of a larger scrollable view.
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Displays 3 shimmer loading post items.
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section of the post shimmer: Avatar and Name/Time placeholders
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  // Shimmer for the user's profile picture
                  ShimmerLoader(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color.fromARGB(255, 45, 185, 185),
                        child: CircleAvatar(
                          radius: 17,
                          // Placeholder for the profile image
                          backgroundImage: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shimmer for the user's name and post time
                        ShimmerLoader(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Placeholder for the name
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: Get.width - 100,
                              ),
                              const SizedBox(height: 7),
                              // Placeholder for the time/additional info
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: Get.width / 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Middle section of the post shimmer: Image/Content placeholder
            ShimmerLoader(
              child: Container(
                width: double.maxFinite,
                height: 256, // Fixed height for the content area
                decoration: const BoxDecoration(
                  color: Colors.grey, // Placeholder color
                ),
              ),
            ),
            // Bottom section of the post shimmer: Action buttons (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Shimmer for the Like button
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.LIKE_ICON,
                    text: 'Like'.tr,
                    onPressed: () {}, // No action during shimmer
                  ),
                ),
                // Shimmer for the Comment button
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.COMMENT_ACTION_ICON,
                    text: 'Comment'.tr,
                    onPressed: () {}, // No action during shimmer
                  ),
                ),
                // Shimmer for the Share button
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.SHARE_ACTION_ICON,
                    text: 'Share'.tr,
                    onPressed: () {}, // No action during shimmer
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
