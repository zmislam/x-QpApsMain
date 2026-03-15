import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import 'other_albums_component.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../components/single_image.dart';
import '../../../../../config/constants/app_assets.dart';


class OtherPhotosComponent extends StatelessWidget {
  final OthersProfileController controller;
  const OtherPhotosComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);

    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Albums section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Albums'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          OtherAlbumsComponent(userName: controller.username ?? ''),
          const SizedBox(height: 16),

          // All Photos section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All Photos'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.photoList.value.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No photos to show'.tr,
                        style: TextStyle(fontSize: 14, color: textSecondary),
                      ),
                    ),
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: controller.photoList.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final photoUrl = ('${controller.photoList.value[index].media}')
                          .formatedPostUrl;
                      return GestureDetector(
                        onTap: () =>
                            Get.to(() => SingleImage(imgURL: photoUrl)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppAssets.DEFAULT_IMAGE,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
