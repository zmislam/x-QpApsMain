import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_remix_model.dart';
import '../controllers/reels_remix_controller.dart';

/// Remix chain viewer — displays the full lineage tree of remixes for a reel.
class RemixChainViewer extends StatelessWidget {
  final String reelId;

  const RemixChainViewer({super.key, required this.reelId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsRemixController>();

    // Load chain on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRemixChain(reelId);
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Remix Chain',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Obx(() {
            if (controller.isLoadingChain.value) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              );
            }

            if (controller.remixChain.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.loop, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('This is the original reel',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.remixChain.length,
                itemBuilder: (context, index) {
                  final remix = controller.remixChain[index];
                  final isLast = index == controller.remixChain.length - 1;
                  return _RemixChainNode(
                    remix: remix,
                    isOriginal: index == 0,
                    isLast: isLast,
                    onTap: () {
                      // Navigate to that reel
                      if (remix.reelId != null) {
                        Get.back();
                        // Navigate to reel detail
                      }
                    },
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RemixChainNode extends StatelessWidget {
  final ReelRemixModel remix;
  final bool isOriginal;
  final bool isLast;
  final VoidCallback onTap;

  const _RemixChainNode({
    required this.remix,
    required this.isOriginal,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                if (!isOriginal)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey[700]),
                  ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOriginal ? Colors.blue : Colors.grey[600],
                    border: Border.all(
                      color: isOriginal ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: isOriginal
                      ? Border.all(color: Colors.blue.withOpacity(0.3))
                      : null,
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 40,
                        height: 56,
                        color: Colors.grey[800],
                        child: remix.thumbnailUrl != null
                            ? Image.network(remix.thumbnailUrl!,
                                fit: BoxFit.cover)
                            : const Icon(Icons.play_arrow,
                                color: Colors.white38, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isOriginal)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('ORIGINAL',
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              Text(
                                '@${remix.authorName ?? 'unknown'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _remixTypeLabel(remix.remixType),
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: Colors.white38, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _remixTypeLabel(String? type) {
    switch (type) {
      case 'duet':
        return 'Duet';
      case 'stitch':
        return 'Stitch';
      case 'greenScreen':
        return 'Green Screen Remix';
      default:
        return 'Original';
    }
  }
}
