import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_draft_model.dart';

/// Main editor controller for Reels V2.
/// Manages clips, timeline, text overlays, stickers, drawing,
/// transitions, and undo/redo stack.
class ReelsEditorController extends GetxController {
  // ─── Draft / Clips ─────────────────────────────────────
  ReelDraftModel? draft;
  final RxList<EditClip> clips = <EditClip>[].obs;
  final RxInt selectedClipIndex = (-1).obs;
  final RxBool isPlaying = false.obs;
  final RxDouble currentTime = 0.0.obs;

  // ─── Text Overlays ────────────────────────────────────
  final RxList<TextOverlay> textOverlays = <TextOverlay>[].obs;
  final RxInt selectedTextIndex = (-1).obs;

  // ─── Stickers ──────────────────────────────────────────
  final RxList<StickerOverlay> stickers = <StickerOverlay>[].obs;
  final RxInt selectedStickerIndex = (-1).obs;

  // ─── Drawing ───────────────────────────────────────────
  final RxList<DrawingStroke> drawingStrokes = <DrawingStroke>[].obs;
  final RxBool isDrawingMode = false.obs;
  final RxBool isEraserMode = false.obs;
  final RxDouble brushSize = 4.0.obs;
  final Rx<Color> brushColor = Colors.white.obs;

  // ─── Editor Mode ───────────────────────────────────────
  final Rx<EditorMode> currentMode = EditorMode.timeline.obs;

  // ─── Undo / Redo Stack ─────────────────────────────────
  final ListQueue<EditorAction> _undoStack = ListQueue<EditorAction>();
  final ListQueue<EditorAction> _redoStack = ListQueue<EditorAction>();
  static const int _maxUndoSize = 30;
  final RxBool canUndo = false.obs;
  final RxBool canRedo = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Receive draft from camera
    if (Get.arguments is ReelDraftModel) {
      draft = Get.arguments as ReelDraftModel;
      _initClipsFromDraft();
    }
  }

  void _initClipsFromDraft() {
    if (draft == null) return;
    int idx = 0;

    // Add recorded segments
    for (final segPath in draft!.segments) {
      clips.add(EditClip(
        id: 'seg_$idx',
        filePath: segPath,
        type: ClipType.video,
        startTrim: 0,
        endTrim: 0,
        speed: draft!.speed ?? 1.0,
      ));
      idx++;
    }

    // Add gallery files
    for (final galPath in draft!.galleryFiles) {
      final isVideo = galPath.endsWith('.mp4') ||
          galPath.endsWith('.mov') ||
          galPath.endsWith('.avi');
      clips.add(EditClip(
        id: 'gal_$idx',
        filePath: galPath,
        type: isVideo ? ClipType.video : ClipType.image,
        startTrim: 0,
        endTrim: 0,
        speed: 1.0,
      ));
      idx++;
    }

    if (clips.isNotEmpty) selectedClipIndex.value = 0;
  }

  // ═══════════════════════════════════════════════════════
  // CLIPS
  // ═══════════════════════════════════════════════════════

  void selectClip(int index) {
    if (index >= 0 && index < clips.length) {
      selectedClipIndex.value = index;
    }
  }

  void reorderClips(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final clip = clips.removeAt(oldIndex);
    clips.insert(newIndex, clip);
    _pushAction(EditorAction(
      type: ActionType.reorderClip,
      data: {'from': oldIndex, 'to': newIndex},
    ));
  }

  void removeClip(int index) {
    if (index >= 0 && index < clips.length) {
      final removed = clips.removeAt(index);
      _pushAction(EditorAction(
        type: ActionType.removeClip,
        data: {'index': index, 'clip': removed},
      ));
      if (selectedClipIndex.value >= clips.length) {
        selectedClipIndex.value = clips.length - 1;
      }
    }
  }

  void setClipTrim(int index, double startTrim, double endTrim) {
    if (index >= 0 && index < clips.length) {
      clips[index] = clips[index].copyWith(
        startTrim: startTrim,
        endTrim: endTrim,
      );
      clips.refresh();
      _pushAction(EditorAction(
        type: ActionType.trimClip,
        data: {'index': index, 'start': startTrim, 'end': endTrim},
      ));
    }
  }

  void setClipSpeed(int index, double speed) {
    if (index >= 0 && index < clips.length) {
      clips[index] = clips[index].copyWith(speed: speed);
      clips.refresh();
      _pushAction(EditorAction(
        type: ActionType.speedClip,
        data: {'index': index, 'speed': speed},
      ));
    }
  }

  void setClipTransition(int index, TransitionType transition) {
    if (index >= 0 && index < clips.length) {
      clips[index] = clips[index].copyWith(transition: transition);
      clips.refresh();
    }
  }

  // ═══════════════════════════════════════════════════════
  // TEXT OVERLAYS
  // ═══════════════════════════════════════════════════════

  void addTextOverlay(TextOverlay overlay) {
    textOverlays.add(overlay);
    selectedTextIndex.value = textOverlays.length - 1;
    _pushAction(EditorAction(
      type: ActionType.addText,
      data: {'index': textOverlays.length - 1},
    ));
  }

  void updateTextOverlay(int index, TextOverlay updated) {
    if (index >= 0 && index < textOverlays.length) {
      textOverlays[index] = updated;
      textOverlays.refresh();
    }
  }

  void removeTextOverlay(int index) {
    if (index >= 0 && index < textOverlays.length) {
      textOverlays.removeAt(index);
      selectedTextIndex.value = -1;
      _pushAction(EditorAction(
        type: ActionType.removeText,
        data: {'index': index},
      ));
    }
  }

  void selectText(int index) {
    selectedTextIndex.value = index;
    selectedStickerIndex.value = -1;
  }

  // ═══════════════════════════════════════════════════════
  // STICKERS
  // ═══════════════════════════════════════════════════════

  void addSticker(StickerOverlay sticker) {
    stickers.add(sticker);
    selectedStickerIndex.value = stickers.length - 1;
    _pushAction(EditorAction(
      type: ActionType.addSticker,
      data: {'index': stickers.length - 1},
    ));
  }

  void updateSticker(int index, StickerOverlay updated) {
    if (index >= 0 && index < stickers.length) {
      stickers[index] = updated;
      stickers.refresh();
    }
  }

  void removeSticker(int index) {
    if (index >= 0 && index < stickers.length) {
      stickers.removeAt(index);
      selectedStickerIndex.value = -1;
    }
  }

  void selectSticker(int index) {
    selectedStickerIndex.value = index;
    selectedTextIndex.value = -1;
  }

  // ═══════════════════════════════════════════════════════
  // DRAWING
  // ═══════════════════════════════════════════════════════

  void toggleDrawingMode() {
    isDrawingMode.value = !isDrawingMode.value;
    if (!isDrawingMode.value) isEraserMode.value = false;
    currentMode.value =
        isDrawingMode.value ? EditorMode.drawing : EditorMode.timeline;
  }

  void toggleEraserMode() {
    isEraserMode.value = !isEraserMode.value;
  }

  void addStroke(DrawingStroke stroke) {
    drawingStrokes.add(stroke);
    _pushAction(EditorAction(
      type: ActionType.addDrawing,
      data: {'index': drawingStrokes.length - 1},
    ));
  }

  void eraseStroke(int index) {
    if (index >= 0 && index < drawingStrokes.length) {
      drawingStrokes.removeAt(index);
    }
  }

  void clearDrawing() {
    drawingStrokes.clear();
  }

  // ═══════════════════════════════════════════════════════
  // EDITOR MODE
  // ═══════════════════════════════════════════════════════

  void setMode(EditorMode mode) {
    currentMode.value = mode;
    if (mode != EditorMode.drawing) {
      isDrawingMode.value = false;
      isEraserMode.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════
  // UNDO / REDO
  // ═══════════════════════════════════════════════════════

  void _pushAction(EditorAction action) {
    _undoStack.addLast(action);
    if (_undoStack.length > _maxUndoSize) {
      _undoStack.removeFirst();
    }
    _redoStack.clear();
    canUndo.value = _undoStack.isNotEmpty;
    canRedo.value = false;
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    final action = _undoStack.removeLast();
    _redoStack.addLast(action);
    canUndo.value = _undoStack.isNotEmpty;
    canRedo.value = true;
    // The actual reversal logic would be more complex in production
    // This provides the stack infrastructure
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final action = _redoStack.removeLast();
    _undoStack.addLast(action);
    canUndo.value = true;
    canRedo.value = _redoStack.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════
  // PREVIEW / EXPORT
  // ═══════════════════════════════════════════════════════

  void togglePlayback() {
    isPlaying.value = !isPlaying.value;
  }

  void seekTo(double seconds) {
    currentTime.value = seconds;
  }

  double get totalDuration {
    double total = 0;
    for (final clip in clips) {
      total += clip.effectiveDuration;
    }
    return total;
  }

  /// Proceed to preview/publish
  void proceedToPreview() {
    Get.toNamed('/reels-v2/preview', arguments: {
      'clips': clips.toList(),
      'textOverlays': textOverlays.toList(),
      'stickers': stickers.toList(),
      'drawingStrokes': drawingStrokes.toList(),
    });
  }
}

// ─── Data Models ────────────────────────────────────────

enum EditorMode { timeline, text, sticker, drawing, filter }

enum ClipType { video, image }

enum TransitionType { none, fade, slide, zoom, dissolve }

enum ActionType {
  addClip,
  removeClip,
  reorderClip,
  trimClip,
  speedClip,
  addText,
  removeText,
  addSticker,
  removeSticker,
  addDrawing,
  removeDrawing,
}

class EditorAction {
  final ActionType type;
  final Map<String, dynamic> data;
  EditorAction({required this.type, this.data = const {}});
}

class EditClip {
  final String id;
  final String filePath;
  final ClipType type;
  final double startTrim; // seconds from start
  final double endTrim; // seconds from end
  final double speed;
  final double? durationSeconds; // raw duration
  final TransitionType transition;

  EditClip({
    required this.id,
    required this.filePath,
    required this.type,
    this.startTrim = 0,
    this.endTrim = 0,
    this.speed = 1.0,
    this.durationSeconds,
    this.transition = TransitionType.none,
  });

  double get effectiveDuration {
    final raw = durationSeconds ?? 5.0; // default 5s for images
    return (raw - startTrim - endTrim) / speed;
  }

  EditClip copyWith({
    String? id,
    String? filePath,
    ClipType? type,
    double? startTrim,
    double? endTrim,
    double? speed,
    double? durationSeconds,
    TransitionType? transition,
  }) {
    return EditClip(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      startTrim: startTrim ?? this.startTrim,
      endTrim: endTrim ?? this.endTrim,
      speed: speed ?? this.speed,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      transition: transition ?? this.transition,
    );
  }
}

class TextOverlay {
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final Offset position;
  final double rotation;
  final double scale;
  final String? animation; // fadeIn, slideUp, typewriter, etc.
  final double startTime; // seconds
  final double endTime; // seconds

  TextOverlay({
    required this.text,
    this.fontFamily = 'Roboto',
    this.fontSize = 24,
    this.color = Colors.white,
    this.backgroundColor,
    this.backgroundOpacity = 0.0,
    this.position = const Offset(0.5, 0.5),
    this.rotation = 0,
    this.scale = 1.0,
    this.animation,
    this.startTime = 0,
    this.endTime = double.infinity,
  });

  TextOverlay copyWith({
    String? text,
    String? fontFamily,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    double? backgroundOpacity,
    Offset? position,
    double? rotation,
    double? scale,
    String? animation,
    double? startTime,
    double? endTime,
  }) {
    return TextOverlay(
      text: text ?? this.text,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      animation: animation ?? this.animation,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class StickerOverlay {
  final String id;
  final StickerType type;
  final String url; // GIF URL, emoji, or asset path
  final Offset position;
  final double rotation;
  final double scale;
  final double startTime;
  final double endTime;
  final Map<String, dynamic>? interactiveData; // for poll/quiz

  StickerOverlay({
    required this.id,
    required this.type,
    required this.url,
    this.position = const Offset(0.5, 0.5),
    this.rotation = 0,
    this.scale = 1.0,
    this.startTime = 0,
    this.endTime = double.infinity,
    this.interactiveData,
  });

  StickerOverlay copyWith({
    Offset? position,
    double? rotation,
    double? scale,
    double? startTime,
    double? endTime,
    Map<String, dynamic>? interactiveData,
  }) {
    return StickerOverlay(
      id: id,
      type: type,
      url: url,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      interactiveData: interactiveData ?? this.interactiveData,
    );
  }
}

enum StickerType { gif, emoji, mention, hashtag, poll, quiz }

class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final StrokeCap strokeCap;

  DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
    this.strokeCap = StrokeCap.round,
  });
}
