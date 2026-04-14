import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_collection_controller.dart';

class CollectionPickerSheet extends StatelessWidget {
  final String reelId;
  const CollectionPickerSheet({super.key, required this.reelId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCollectionController>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Save to collection',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _showCreateDialog(context, controller);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.blue, size: 18),
                      SizedBox(width: 4),
                      Text('New',
                          style: TextStyle(color: Colors.blue, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, height: 1),
          // Collection list
          Expanded(
            child: Obx(() {
              if (controller.collections.isEmpty) {
                return const Center(
                  child: Text('No collections yet',
                      style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.builder(
                itemCount: controller.collections.length,
                itemBuilder: (context, index) {
                  final col = controller.collections[index];
                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                        image: (col.coverUrls?.isNotEmpty ?? false)
                            ? DecorationImage(
                                image: NetworkImage(col.coverUrls!.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (col.coverUrls?.isEmpty ?? true)
                          ? const Icon(Icons.bookmark,
                              color: Colors.grey, size: 22)
                          : null,
                    ),
                    title: Text(col.name,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${col.reelCount} reels',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () {
                      controller.addToCollection(col.id, reelId);
                      Get.back();
                      Get.snackbar('Saved', 'Added to ${col.name}',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(
      BuildContext context, ReelsCollectionController controller) {
    final nameCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('New Collection',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Collection name',
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                controller.createCollection(name);
                Get.back();
              }
            },
            child: const Text('Create', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
