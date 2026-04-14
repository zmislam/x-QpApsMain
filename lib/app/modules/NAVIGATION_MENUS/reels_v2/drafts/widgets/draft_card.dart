import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/reel_draft_model.dart';

/// Draft card for the drafts grid — shows thumbnail, duration, and selection state.
class DraftCard extends StatelessWidget {
  final ReelDraftModel draft;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DraftCard({
    super.key,
    required this.draft,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail
          _buildThumbnail(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),

          // Duration badge
          if (draft.durationLimit != null)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(draft.durationLimit!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Caption preview
          if (draft.description != null && draft.description!.isNotEmpty)
            Positioned(
              bottom: 4,
              right: 4,
              child: const Icon(
                Icons.text_fields,
                color: Colors.white54,
                size: 14,
              ),
            ),

          // Auto-saved indicator
          if (draft.updatedAt != null)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _timeAgo(draft.updatedAt!),
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 9),
                ),
              ),
            ),

          // Selection overlay
          if (isSelectionMode)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.blue
                      : Colors.white.withOpacity(0.3),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    if (draft.thumbnailPath != null) {
      final file = File(draft.thumbnailPath!);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }
    // Fallback — dark placeholder
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.videocam_outlined, color: Colors.white24, size: 32),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.month}/${dt.day}';
  }
}
