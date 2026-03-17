import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import 'admin_album_card.dart';
import '../controller/admin_page_controller.dart';
import '../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../components/single_image.dart';
import '../../../../../../../config/constants/app_assets.dart';

/// Facebook-style Photos tab for Admin Page Profile
class AdminPagePhotosComponent extends StatelessWidget {
  const AdminPagePhotosComponent({super.key, required this.controller});

  final AdminPageController controller;

  @override
  Widget build(BuildContext context) {
    controller.getPagePhotos(
        controller.pageProfileModel.value?.pageDetails?.pageUserName ?? '');

    final bgColor = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final brand = FeedDesignTokens.brand(context);

    return SliverToBoxAdapter(
      child: Container(
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Recent Photos Header + All Albums link ────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent photos'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'All albums'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: brand,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Album Cards ──────────────────────────────────
            SizedBox(
              height: 150,
              child: AdminAlbumCard(controller: controller),
            ),

            const SizedBox(height: 8),
            Divider(
                color: FeedDesignTokens.divider(context),
                height: 1,
                indent: 16,
                endIndent: 16),

            // ─── All Photos Header ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'All photos'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ),

            // ─── Photo Grid ────────────────────────────────────
            Obx(() {
              if (controller.isLoadingUserPhoto.value) {
                return _buildPhotoGridShimmer(context);
              }

              if (controller.pagePhotosList.value.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.photo_library_outlined,
                            size: 48, color: textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'No photos yet'.tr,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemCount: controller.pagePhotosList.value.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  final photoUrl =
                      ('${controller.pagePhotosList.value[index].media}')
                          .formatedPostUrl;
                  return GestureDetector(
                    onTap: () => Get.to(() => SingleImage(imgURL: photoUrl)),
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        AppAssets.DEFAULT_IMAGE,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGridShimmer(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return ShimmerLoader(
          child: Container(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }
}
