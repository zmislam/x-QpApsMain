import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_collection_controller.dart';
import '../../models/reel_collection_model.dart';

class CollectionDetailView extends GetView<ReelsCollectionController> {
  const CollectionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final collection = Get.arguments as ReelCollectionModel?;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          collection?.name ?? 'Collection',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.collectionReelsLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        if (controller.collectionReels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border,
                    color: Colors.grey[700], size: 64),
                const SizedBox(height: 16),
                const Text('No reels in this collection',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() => Text(
                '${controller.collectionReels.length} reels',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              )),
            ),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 9 / 16,
                ),
                itemCount: controller.collectionReels.length,
                itemBuilder: (context, index) {
                  final reel = controller.collectionReels[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.toNamed('/reels-v2/preview', arguments: reel),
                    onLongPress: () {
                      if (collection != null) {
                        _showRemoveDialog(context, collection.id, reel.id);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(4),
                        image: reel.thumbnailUrl != null
                            ? DecorationImage(
                                image: NetworkImage(reel.thumbnailUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                _formatCount(reel.viewCount ?? 0),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showRemoveDialog(
      BuildContext context, String collectionId, String reelId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Remove from collection?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              controller.removeFromCollection(collectionId, reelId);
              Get.back();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
