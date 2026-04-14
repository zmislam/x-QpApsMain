import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';

/// Draggable, scalable, rotatable sticker overlay.
/// Positioned by normalized coordinates (0-1).
/// Supports pinch-to-scale and rotation gestures.
/// Shows delete zone at bottom when dragging.
class DraggableSticker extends StatefulWidget {
  final StickerOverlay sticker;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<StickerOverlay> onUpdate;
  final VoidCallback onDelete;

  const DraggableSticker({
    super.key,
    required this.sticker,
    required this.isSelected,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DraggableSticker> createState() => _DraggableStickerState();
}

class _DraggableStickerState extends State<DraggableSticker> {
  late Offset _position;
  late double _scale;
  late double _rotation;
  double _baseScale = 1.0;
  double _baseRotation = 0.0;
  bool _isDragging = false;
  bool _isInDeleteZone = false;

  @override
  void initState() {
    super.initState();
    _position = widget.sticker.position;
    _scale = widget.sticker.scale;
    _rotation = widget.sticker.rotation;
  }

  @override
  void didUpdateWidget(DraggableSticker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sticker != widget.sticker) {
      _position = widget.sticker.position;
      _scale = widget.sticker.scale;
      _rotation = widget.sticker.rotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: _position.dx * screenWidth - 40,
      top: _position.dy * screenHeight * 0.5 + 56 - 40,
      child: GestureDetector(
        onTap: widget.onTap,
        onScaleStart: (details) {
          _baseScale = _scale;
          _baseRotation = _rotation;
          setState(() => _isDragging = true);
        },
        onScaleUpdate: (details) {
          setState(() {
            // Update position
            _position = Offset(
              (_position.dx + details.focalPointDelta.dx / screenWidth)
                  .clamp(0.0, 1.0),
              (_position.dy + details.focalPointDelta.dy / (screenHeight * 0.5))
                  .clamp(0.0, 1.0),
            );
            // Update scale
            _scale = (_baseScale * details.scale).clamp(0.3, 4.0);
            // Update rotation
            _rotation = _baseRotation + details.rotation;
            // Check delete zone (bottom 15% of screen)
            final absoluteY =
                _position.dy * screenHeight * 0.5 + 56;
            _isInDeleteZone =
                absoluteY > screenHeight * 0.85;
          });
        },
        onScaleEnd: (details) {
          setState(() => _isDragging = false);
          if (_isInDeleteZone) {
            widget.onDelete();
          } else {
            widget.onUpdate(widget.sticker.copyWith(
              position: _position,
              scale: _scale,
              rotation: _rotation,
            ));
          }
          _isInDeleteZone = false;
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Transform.scale(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: widget.isSelected
                    ? Border.all(color: Colors.blueAccent, width: 1.5)
                    : null,
                boxShadow: _isDragging
                    ? [
                        BoxShadow(
                          color: _isInDeleteZone
                              ? Colors.red.withValues(alpha: 0.4)
                              : Colors.black45,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: _buildStickerContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickerContent() {
    switch (widget.sticker.type) {
      case StickerType.emoji:
        return Text(
          widget.sticker.url,
          style: const TextStyle(fontSize: 48),
        );
      case StickerType.gif:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.gif, color: Colors.white54, size: 32),
          ),
        );
      case StickerType.poll:
        return _buildPollSticker();
      case StickerType.quiz:
        return _buildQuizSticker();
      case StickerType.mention:
        return _buildMentionSticker();
      case StickerType.hashtag:
        return _buildHashtagSticker();
    }
  }

  Widget _buildPollSticker() {
    final data = widget.sticker.interactiveData;
    final question = data?['question'] ?? 'Poll';
    final options = (data?['options'] as List?)?.cast<String>() ?? [];

    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ...options.map((opt) => Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildQuizSticker() {
    final data = widget.sticker.interactiveData;
    final question = data?['question'] ?? 'Quiz';

    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.quiz, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMentionSticker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.alternate_email, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            widget.sticker.interactiveData?['username'] ?? 'mention',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagSticker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tag, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            widget.sticker.interactiveData?['tag'] ?? 'hashtag',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
