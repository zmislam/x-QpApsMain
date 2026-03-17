import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../model/reels_model.dart';
import '../controllers/watched_reels_controller.dart';

class WatchedReelsView extends GetView<WatchedReelsController> {
  const WatchedReelsView({super.key});

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
          "Reels that you've watched",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.watchedReels.value.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.black54),
              tooltip: 'Clear all history',
              onPressed: () => controller.clearAllHistory(context),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
          );
        }

        final reels = controller.watchedReels.value;

        if (reels.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, color: Colors.grey.shade300, size: 48),
                const SizedBox(height: 12),
                Text('No watch history yet',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: reels.length + (controller.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
            itemBuilder: (context, index) {
              if (index >= reels.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
                  ),
                );
              }
              return _buildWatchedReelItem(reels[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildWatchedReelItem(ReelsModel reel) {
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

    return InkWell(
      onTap: () => Get.toNamed(Routes.OTHER_USER_VIDEO, arguments: {'reelsID': reel.id}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with "Watched" badge
            Stack(
              children: [
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
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Watched',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Text info
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  if (creatorName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      creatorName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${_formatCount(reel.view_count ?? 0)} views',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            // 3-dot menu
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 20),
              onPressed: () => _showReelOptions(Get.context!, reel),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  void _showReelOptions(BuildContext context, ReelsModel reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Share
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: Colors.black87),
                  title: const Text('Share', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    final desc = reel.description ?? 'Check out this reel!';
                    final reelLink = '${ApiConstant.SERVER_IP_PORT}/reels/${reel.id}';
                    SharePlus.instance.share(ShareParams(text: '$desc\n$reelLink'));
                  },
                ),
                // Save / Bookmark
                ListTile(
                  leading: const Icon(Icons.bookmark_border, color: Colors.black87),
                  title: const Text('Save reel', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.saveReel(reel.id ?? '');
                    Get.rawSnackbar(
                      message: 'Reel saved',
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                // Not Interested
                ListTile(
                  leading: const Icon(Icons.not_interested, color: Colors.black87),
                  title: const Text('Not interested', style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.markNotInterested(reel.id ?? '');
                  },
                ),
                // Remove from history
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Remove from history',
                      style: TextStyle(fontSize: 15, color: Colors.redAccent)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.removeFromHistory(reel.id ?? '');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
