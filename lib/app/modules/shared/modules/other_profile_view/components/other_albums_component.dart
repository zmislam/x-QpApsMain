import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../views/other_videos_gallery/controller/other_video_gallery_controller.dart';
import '../views/other_videos_gallery/view/other_video_gallery_view.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';

class OtherAlbumsComponent extends StatelessWidget {
  const OtherAlbumsComponent({super.key, required this.userName});
  final String userName;
  @override
  Widget build(BuildContext context) {
    Get.put(OtherVideoGalleryController());
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final inputBg = FeedDesignTokens.inputBg(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _albumCard(
            context: context,
            icon: Icons.photo_library_rounded,
            label: 'Photos'.tr,
            bg: inputBg,
            textColor: textPrimary,
            onTap: () => Get.toNamed(Routes.OTHER_PHOTOS_GALLERY),
          ),
          const SizedBox(width: 8),
          _albumCard(
            context: context,
            icon: Icons.photo_album_rounded,
            label: 'Albums'.tr,
            bg: inputBg,
            textColor: textPrimary,
            onTap: () => Get.toNamed(Routes.OTHER_ALBUMS_GALLERY,
                arguments: userName),
          ),
          const SizedBox(width: 8),
          _albumCard(
            context: context,
            icon: Icons.videocam_rounded,
            label: 'Videos'.tr,
            bg: inputBg,
            textColor: textPrimary,
            onTap: () => Get.to(() => const OtherVideoGalleryView()),
          ),
        ],
      ),
    );
  }

  Widget _albumCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color bg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: PRIMARY_COLOR),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
