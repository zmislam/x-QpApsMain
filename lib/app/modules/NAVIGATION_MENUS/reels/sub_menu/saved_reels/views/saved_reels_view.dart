import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/color.dart';
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
    final firstImage = (reel.image != null && reel.image!.isNotEmpty)
        ? reel.image!.first
        : null;
    final imageUrl = firstImage != null
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$firstImage'
        : '';

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
      onTap: () => Get.back(result: reel.id),
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
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
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
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
