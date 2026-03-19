import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../model/reels_model.dart';
import '../controllers/saved_reels_controller.dart';

class SavedReelsView extends GetView<SavedReelsController> {
  const SavedReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Saved',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
          );
        }

        final reels = controller.savedReels.value;

        if (reels.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_border, color: Colors.grey.shade300, size: 56),
                const SizedBox(height: 12),
                Text(
                  'No saved reels yet',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap the bookmark icon on a reel to save it',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 200) {
              controller.loadMore();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Most recent" header
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    'Most recent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Saved reels list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reels.length + (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE)),
                  itemBuilder: (context, index) {
                    if (index >= reels.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
                        ),
                      );
                    }
                    return _buildSavedReelItem(reels[index]);
                  },
                ),

                // "See all" button
                if (reels.length >= 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.loadMore(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'See all',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSavedReelItem(ReelsModel reel) {
    // Build thumbnail URL - check image first, then video_thumbnail, then derive from video name
    String thumbnailUrl = '';
    if (reel.image != null && reel.image!.isNotEmpty) {
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/${reel.image!.first}';
    } else if (reel.video_thumbnail != null && reel.video_thumbnail!.isNotEmpty) {
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/${reel.video_thumbnail}';
    } else if (reel.video != null && reel.video!.isNotEmpty) {
      // Derive thumbnail from video name: {videoBasename}-thumbnail.png
      final videoName = reel.video!;
      final dotIndex = videoName.lastIndexOf('.');
      final baseName = dotIndex > 0 ? videoName.substring(0, dotIndex) : videoName;
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/$baseName-thumbnail.png';
    }

    final creatorName = reel.reel_user != null
        ? '${reel.reel_user!.first_name ?? ''} ${reel.reel_user!.last_name ?? ''}'.trim()
        : '';

    final description = reel.description ?? '';

    // Format saved time
    String savedTimeText = '';
    if (reel.createdAt != null) {
      try {
        final savedAt = DateTime.parse(reel.createdAt!);
        savedTimeText = 'Saved ${timeago.format(savedAt)}';
      } catch (_) {}
    }

    return InkWell(
      onTap: () => _openReel(reel),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 140,
                height: 90,
                child: thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Colors.grey[200]),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.play_circle_outline,
                              color: Colors.grey, size: 32),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.play_circle_outline,
                            color: Colors.grey, size: 32),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  const SizedBox(height: 3),
                  if (creatorName.isNotEmpty)
                    Text(
                      'Reels · $creatorName',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  if (savedTimeText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          savedTimeText,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // 3-dot menu
            IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.grey.shade600, size: 22),
              onPressed: () => _showReelOptions(reel),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _openReel(ReelsModel reel) {
    Get.toNamed(Routes.REELS, arguments: {'reel_id': reel.id});
  }

  void _showReelOptions(ReelsModel reel) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Unsave option
              ListTile(
                leading: const Icon(Icons.bookmark_remove_outlined, color: Colors.black87),
                title: const Text(
                  'Unsave',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Get.back();
                  controller.unsaveReel(reel.id ?? '');
                },
              ),
              // View Reel option
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: Colors.black87),
                title: const Text(
                  'View Reel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Get.back();
                  _openReel(reel);
                },
              ),
              // View creator profile
              if (reel.reel_user?.username != null && reel.reel_user!.username!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.black87),
                  title: const Text(
                    'View Creator Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Get.back();
                    ProfileNavigator.navigateToProfile(
                      username: reel.reel_user!.username!,
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
