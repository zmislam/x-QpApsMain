import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';

class LocationFeedView extends GetView<ReelsSearchController> {
  const LocationFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final locationId = args?['locationId'] ?? '';
    final locationName = args?['locationName'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLocationFeed(locationId, name: locationName);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Obx(() => Text(
                      controller.currentLocationName.value.isNotEmpty
                          ? controller.currentLocationName.value
                          : locationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ],
              ),
            ),
            // Reel Grid
            Expanded(
              child: Obx(() {
                if (controller.locationFeedLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
                if (controller.locationReels.isEmpty) {
                  return const Center(
                    child: Text('No reels from this location',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 9 / 16,
                  ),
                  itemCount: controller.locationReels.length,
                  itemBuilder: (context, index) {
                    final reel = controller.locationReels[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed('/reels-v2/preview',
                          arguments: reel),
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
                );
              }),
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
}
