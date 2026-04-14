import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_editor_controller.dart';
import 'clip_thumbnail.dart';
import 'trim_handle.dart';
import 'transition_picker.dart';

/// Horizontal scrollable clip timeline with drag-to-reorder,
/// per-clip trim handles, speed controls, and transition pickers.
class ClipTimeline extends StatelessWidget {
  final RxList<EditClip> clips;
  final int selectedIndex;
  final ValueChanged<int> onClipSelected;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ClipTimeline({
    super.key,
    required this.clips,
    required this.selectedIndex,
    required this.onClipSelected,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          // Duration display
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Obx(() {
              final ctrl = Get.find<ReelsEditorController>();
              final total = ctrl.totalDuration;
              return Row(
                children: [
                  Text(
                    '${total.toStringAsFixed(1)}s',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const Spacer(),
                  Text(
                    '${clips.length} clip${clips.length != 1 ? 's' : ''}',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              );
            }),
          ),
          // Scrollable clip strip
          Expanded(
            child: Obx(() => ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  buildDefaultDragHandles: false,
                  itemCount: clips.length,
                  onReorder: onReorder,
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (ctx, ch) => Material(
                        color: Colors.transparent,
                        elevation: 4,
                        child: ch,
                      ),
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final clip = clips[index];
                    final isSelected = index == selectedIndex;

                    return ReorderableDragStartListener(
                      key: ValueKey(clip.id),
                      index: index,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Clip tile
                          GestureDetector(
                            onTap: () => onClipSelected(index),
                            child: _ClipTile(
                              clip: clip,
                              index: index,
                              isSelected: isSelected,
                            ),
                          ),
                          // Transition picker between clips
                          if (index < clips.length - 1)
                            TransitionPicker(
                              clipIndex: index,
                            ),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class _ClipTile extends StatelessWidget {
  final EditClip clip;
  final int index;
  final bool isSelected;

  const _ClipTile({
    required this.clip,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Width proportional to duration (min 60, max 200)
    final width = (clip.effectiveDuration * 20).clamp(60.0, 200.0);

    return Container(
      width: width,
      height: 72,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey[700]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: ClipThumbnail(
              filePath: clip.filePath,
              isVideo: clip.type == ClipType.video,
            ),
          ),
          // Trim handles (visible when selected)
          if (isSelected)
            TrimHandle(
              clipIndex: index,
              clipWidth: width,
            ),
          // Speed badge
          if (clip.speed != 1.0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${clip.speed}x',
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ),
          // Duration label
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${clip.effectiveDuration.toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.white70, fontSize: 9),
              ),
            ),
          ),
          // Clip index
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated proxy decorator for ReorderableListView.
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}
