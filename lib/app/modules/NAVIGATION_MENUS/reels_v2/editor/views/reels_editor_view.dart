import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_editor_controller.dart';
import '../controllers/reels_effects_controller.dart';
import '../widgets/timeline/clip_timeline.dart';
import '../widgets/text/text_editor_overlay.dart';
import '../widgets/sticker/sticker_picker.dart';
import '../widgets/sticker/draggable_sticker.dart';
import '../widgets/drawing/drawing_canvas.dart';

/// Main editor view for Reels V2.
/// Full-screen editor with preview area, mode toolbar, and
/// context-dependent bottom panels (timeline, text, sticker, drawing, filter).
class ReelsEditorView extends GetView<ReelsEditorController> {
  const ReelsEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final effectsCtrl = Get.find<ReelsEffectsController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ─── Top Bar ──────────────────────────────
                _buildTopBar(context),

                // ─── Preview Area ─────────────────────────
                Expanded(child: _buildPreviewArea(effectsCtrl)),

                // ─── Mode Toolbar ─────────────────────────
                _buildModeToolbar(),

                // ─── Bottom Panel ─────────────────────────
                Obx(() => _buildBottomPanel()),
              ],
            ),

            // ─── Text Overlay Layer ─────────────────────
            Obx(() => _buildTextOverlayLayer()),

            // ─── Sticker Overlay Layer ──────────────────
            Obx(() => _buildStickerOverlayLayer()),

            // ─── Drawing Canvas Layer ───────────────────
            Obx(() {
              if (controller.isDrawingMode.value) {
                return Positioned.fill(
                  child: DrawingCanvas(
                    strokes: controller.drawingStrokes,
                    brushColor: controller.brushColor.value,
                    brushSize: controller.brushSize.value,
                    isEraserMode: controller.isEraserMode.value,
                    onStrokeAdded: controller.addStroke,
                    onStrokeErased: controller.eraseStroke,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // ─── Text Editor Overlay ────────────────────
            Obx(() {
              if (controller.currentMode.value == EditorMode.text &&
                  controller.selectedTextIndex.value >= 0) {
                return TextEditorOverlay(
                  overlay: controller.textOverlays[controller.selectedTextIndex.value],
                  onUpdate: (updated) => controller.updateTextOverlay(
                    controller.selectedTextIndex.value,
                    updated,
                  ),
                  onDelete: () => controller.removeTextOverlay(
                    controller.selectedTextIndex.value,
                  ),
                  onDone: () => controller.setMode(EditorMode.timeline),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showDiscardDialog(context),
          ),
          const Spacer(),
          // Undo
          Obx(() => IconButton(
                icon: Icon(
                  Icons.undo,
                  color: controller.canUndo.value
                      ? Colors.white
                      : Colors.white30,
                ),
                onPressed: controller.canUndo.value
                    ? controller.undo
                    : null,
              )),
          // Redo
          Obx(() => IconButton(
                icon: Icon(
                  Icons.redo,
                  color: controller.canRedo.value
                      ? Colors.white
                      : Colors.white30,
                ),
                onPressed: controller.canRedo.value
                    ? controller.redo
                    : null,
              )),
          const SizedBox(width: 8),
          // Next / Preview
          TextButton(
            onPressed: controller.proceedToPreview,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Discard edits?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your changes will be lost.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.back();
            },
            child: const Text('Discard', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // PREVIEW AREA
  // ═══════════════════════════════════════════════════════

  Widget _buildPreviewArea(ReelsEffectsController effectsCtrl) {
    return GestureDetector(
      onTap: controller.togglePlayback,
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Obx(() {
              if (controller.clips.isEmpty) {
                return const Center(
                  child: Text('No clips', style: TextStyle(color: Colors.white54)),
                );
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Video thumbnail placeholder
                  Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.play_arrow, color: Colors.white54, size: 64),
                    ),
                  ),
                  // Filter overlay
                  if (effectsCtrl.currentColorFilter != null)
                    ColorFiltered(
                      colorFilter: effectsCtrl.currentColorFilter!,
                      child: Container(),
                    ),
                  // Play/Pause indicator
                  if (!controller.isPlaying.value)
                    const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white70,
                        size: 64,
                      ),
                    ),
                  // Drawing strokes preview (when not in drawing mode)
                  if (!controller.isDrawingMode.value &&
                      controller.drawingStrokes.isNotEmpty)
                    CustomPaint(
                      painter: _DrawingPreviewPainter(
                        controller.drawingStrokes,
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // MODE TOOLBAR
  // ═══════════════════════════════════════════════════════

  Widget _buildModeToolbar() {
    final modes = [
      _ModeItem(EditorMode.timeline, Icons.movie_edit, 'Clips'),
      _ModeItem(EditorMode.text, Icons.text_fields, 'Text'),
      _ModeItem(EditorMode.sticker, Icons.sticky_note_2, 'Stickers'),
      _ModeItem(EditorMode.drawing, Icons.draw, 'Draw'),
      _ModeItem(EditorMode.filter, Icons.auto_fix_high, 'Effects'),
    ];

    return Container(
      height: 60,
      color: Colors.black,
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: modes.map((m) {
              final isActive = controller.currentMode.value == m.mode;
              return GestureDetector(
                onTap: () {
                  if (m.mode == EditorMode.drawing) {
                    controller.toggleDrawingMode();
                  } else {
                    controller.setMode(m.mode);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      m.icon,
                      color: isActive ? Colors.blueAccent : Colors.white60,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.label,
                      style: TextStyle(
                        color: isActive ? Colors.blueAccent : Colors.white60,
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
    );
  }

  // ═══════════════════════════════════════════════════════
  // BOTTOM PANEL (context-dependent)
  // ═══════════════════════════════════════════════════════

  Widget _buildBottomPanel() {
    switch (controller.currentMode.value) {
      case EditorMode.timeline:
        return SizedBox(
          height: 120,
          child: ClipTimeline(
            clips: controller.clips,
            selectedIndex: controller.selectedClipIndex.value,
            onClipSelected: controller.selectClip,
            onReorder: controller.reorderClips,
          ),
        );
      case EditorMode.text:
        return _buildTextPanel();
      case EditorMode.sticker:
        return SizedBox(
          height: 300,
          child: StickerPicker(
            onStickerSelected: (sticker) {
              controller.addSticker(sticker);
              controller.setMode(EditorMode.timeline);
            },
          ),
        );
      case EditorMode.drawing:
        return _buildDrawingPanel();
      case EditorMode.filter:
        return _buildFilterPanel();
    }
  }

  Widget _buildTextPanel() {
    return Container(
      height: 60,
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _panelButton(Icons.add, 'Add Text', () {
            controller.addTextOverlay(TextOverlay(text: 'Tap to edit'));
          }),
          const Spacer(),
          if (controller.selectedTextIndex.value >= 0) ...[
            _panelButton(Icons.delete_outline, 'Delete', () {
              controller.removeTextOverlay(controller.selectedTextIndex.value);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawingPanel() {
    return Container(
      height: 80,
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Brush size slider
          Expanded(
            child: Obx(() => Slider(
                  value: controller.brushSize.value,
                  min: 1.0,
                  max: 30.0,
                  activeColor: Colors.white,
                  onChanged: (v) => controller.brushSize.value = v,
                )),
          ),
          // Color circles
          ..._colorOptions(),
          const SizedBox(width: 8),
          // Eraser toggle
          Obx(() => IconButton(
                icon: Icon(
                  Icons.auto_fix_normal,
                  color: controller.isEraserMode.value
                      ? Colors.blueAccent
                      : Colors.white60,
                ),
                onPressed: controller.toggleEraserMode,
              )),
          // Clear
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white60),
            onPressed: controller.clearDrawing,
          ),
        ],
      ),
    );
  }

  List<Widget> _colorOptions() {
    const colors = [
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];
    return colors.map((c) {
      return GestureDetector(
        onTap: () => controller.brushColor.value = c,
        child: Obx(() => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.brushColor.value == c
                      ? Colors.blueAccent
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            )),
      );
    }).toList();
  }

  Widget _buildFilterPanel() {
    final effectsCtrl = Get.find<ReelsEffectsController>();
    return Container(
      height: 140,
      color: Colors.grey[900],
      child: Column(
        children: [
          // Intensity slider
          Obx(() => Slider(
                value: effectsCtrl.filterIntensity.value,
                min: 0.0,
                max: 1.0,
                activeColor: Colors.blueAccent,
                onChanged: effectsCtrl.setFilterIntensity,
              )),
          // Filter list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: ReelsEffectsController.availableFilters.length,
              itemBuilder: (context, index) {
                final filter = ReelsEffectsController.availableFilters[index];
                return Obx(() {
                  final isActive = effectsCtrl.selectedFilter.value == filter.id;
                  return GestureDetector(
                    onTap: () => effectsCtrl.selectFilter(filter.id),
                    child: Container(
                      width: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive ? Colors.blueAccent : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.white38,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            filter.name,
                            style: TextStyle(
                              color: isActive ? Colors.blueAccent : Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // OVERLAY LAYERS
  // ═══════════════════════════════════════════════════════

  Widget _buildTextOverlayLayer() {
    if (controller.textOverlays.isEmpty) return const SizedBox.shrink();
    return Stack(
      children: controller.textOverlays.asMap().entries.map((entry) {
        final idx = entry.key;
        final overlay = entry.value;
        return Positioned(
          left: overlay.position.dx * Get.width,
          top: overlay.position.dy * Get.height * 0.5 + 56,
          child: GestureDetector(
            onTap: () {
              controller.selectText(idx);
              controller.setMode(EditorMode.text);
            },
            onPanUpdate: (details) {
              final newPos = Offset(
                (overlay.position.dx + details.delta.dx / Get.width)
                    .clamp(0.0, 1.0),
                (overlay.position.dy + details.delta.dy / (Get.height * 0.5))
                    .clamp(0.0, 1.0),
              );
              controller.updateTextOverlay(
                idx,
                overlay.copyWith(position: newPos),
              );
            },
            child: Transform.rotate(
              angle: overlay.rotation,
              child: Transform.scale(
                scale: overlay.scale,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (overlay.backgroundColor ?? Colors.transparent)
                        .withValues(alpha: overlay.backgroundOpacity),
                    borderRadius: BorderRadius.circular(4),
                    border: controller.selectedTextIndex.value == idx
                        ? Border.all(color: Colors.blueAccent, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    overlay.text,
                    style: TextStyle(
                      fontFamily: overlay.fontFamily,
                      fontSize: overlay.fontSize,
                      color: overlay.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStickerOverlayLayer() {
    if (controller.stickers.isEmpty) return const SizedBox.shrink();
    return Stack(
      children: controller.stickers.asMap().entries.map((entry) {
        final idx = entry.key;
        final sticker = entry.value;
        return DraggableSticker(
          sticker: sticker,
          isSelected: controller.selectedStickerIndex.value == idx,
          onTap: () => controller.selectSticker(idx),
          onUpdate: (updated) => controller.updateSticker(idx, updated),
          onDelete: () => controller.removeSticker(idx),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════

  Widget _panelButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Helper Classes ──────────────────────────────────────

class _ModeItem {
  final EditorMode mode;
  final IconData icon;
  final String label;
  const _ModeItem(this.mode, this.icon, this.label);
}

class _DrawingPreviewPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  _DrawingPreviewPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = stroke.strokeCap
        ..style = PaintingStyle.stroke;
      if (stroke.points.length < 2) continue;
      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPreviewPainter oldDelegate) => true;
}
