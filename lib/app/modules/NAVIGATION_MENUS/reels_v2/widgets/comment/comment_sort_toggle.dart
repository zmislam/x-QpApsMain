import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_comment_controller.dart';
import '../../utils/reel_enums.dart';

/// Sort toggle for comments — Top / Newest.
class CommentSortToggle extends StatelessWidget {
  final Function(CommentSortOption) onChanged;

  const CommentSortToggle({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCommentController>();

    return Obx(() {
      final current = controller.sortOption.value;
      return PopupMenuButton<CommentSortOption>(
        onSelected: onChanged,
        color: const Color(0xFF333333),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        offset: const Offset(0, 30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current == CommentSortOption.top ? 'Top' : 'Newest',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.swap_vert, color: Colors.white54, size: 16),
          ],
        ),
        itemBuilder: (_) => [
          _buildItem(CommentSortOption.top, 'Top comments', current),
          _buildItem(CommentSortOption.newest, 'Newest first', current),
        ],
      );
    });
  }

  PopupMenuItem<CommentSortOption> _buildItem(
    CommentSortOption option,
    String label,
    CommentSortOption current,
  ) {
    final isSelected = option == current;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(Icons.check, color: Colors.white, size: 16),
          ],
        ],
      ),
    );
  }
}
