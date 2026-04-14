import 'package:flutter/material.dart';
import '../../controllers/reels_editor_controller.dart';
import 'font_picker.dart';
import 'text_animation_picker.dart';
import 'text_timing_slider.dart';

/// Full-screen text editor overlay.
/// Inline editing with font, color, background, size, animation, and timing.
class TextEditorOverlay extends StatefulWidget {
  final TextOverlay overlay;
  final ValueChanged<TextOverlay> onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onDone;

  const TextEditorOverlay({
    super.key,
    required this.overlay,
    required this.onUpdate,
    required this.onDelete,
    required this.onDone,
  });

  @override
  State<TextEditorOverlay> createState() => _TextEditorOverlayState();
}

class _TextEditorOverlayState extends State<TextEditorOverlay> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late TextOverlay _current;
  bool _showTimingSlider = false;

  @override
  void initState() {
    super.initState();
    _current = widget.overlay;
    _textController = TextEditingController(text: _current.text);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateOverlay(TextOverlay updated) {
    setState(() => _current = updated);
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: SafeArea(
        child: Column(
          children: [
            // ─── Top Toolbar ──────────────────────────
            _buildToolbar(),

            // ─── Text Input Area ──────────────────────
            Expanded(child: _buildTextInput()),

            // ─── Font & Style Controls ────────────────
            _buildStyleControls(),

            // ─── Color Picker ─────────────────────────
            _buildColorPicker(),

            // ─── Animation Picker ─────────────────────
            TextAnimationPicker(
              selected: _current.animation ?? 'none',
              onSelected: (anim) {
                _updateOverlay(_current.copyWith(animation: anim));
              },
            ),

            // ─── Timing Slider ────────────────────────
            if (_showTimingSlider)
              TextTimingSlider(
                startTime: _current.startTime,
                endTime: _current.endTime,
                onStartChanged: (v) {
                  _updateOverlay(_current.copyWith(startTime: v));
                },
                onEndChanged: (v) {
                  _updateOverlay(_current.copyWith(endTime: v));
                },
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // TOOLBAR
  // ═══════════════════════════════════════════════════════

  Widget _buildToolbar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: widget.onDone,
          ),
          const Spacer(),
          // Toggle timing
          IconButton(
            icon: Icon(
              Icons.timer,
              color: _showTimingSlider ? Colors.blueAccent : Colors.white60,
            ),
            onPressed: () => setState(() => _showTimingSlider = !_showTimingSlider),
          ),
          // Font picker
          IconButton(
            icon: const Icon(Icons.font_download, color: Colors.white60),
            onPressed: () => _showFontPicker(),
          ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: widget.onDelete,
          ),
          // Done
          TextButton(
            onPressed: () {
              _updateOverlay(_current.copyWith(text: _textController.text));
              widget.onDone();
            },
            child: const Text('Done',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // TEXT INPUT
  // ═══════════════════════════════════════════════════════

  Widget _buildTextInput() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: (_current.backgroundColor ?? Colors.transparent)
              .withValues(alpha: _current.backgroundOpacity),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicWidth(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            style: TextStyle(
              fontFamily: _current.fontFamily,
              fontSize: _current.fontSize,
              color: _current.color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Colors.white24),
            ),
            onChanged: (text) {
              _updateOverlay(_current.copyWith(text: text));
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // STYLE CONTROLS
  // ═══════════════════════════════════════════════════════

  Widget _buildStyleControls() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Font size slider
          const Icon(Icons.text_decrease, color: Colors.white38, size: 16),
          Expanded(
            child: Slider(
              value: _current.fontSize,
              min: 12,
              max: 72,
              activeColor: Colors.blueAccent,
              onChanged: (v) {
                _updateOverlay(_current.copyWith(fontSize: v));
              },
            ),
          ),
          const Icon(Icons.text_increase, color: Colors.white38, size: 16),
          const SizedBox(width: 12),
          // Background opacity toggle
          GestureDetector(
            onTap: () {
              final nextOpacity = _current.backgroundOpacity == 0
                  ? 0.5
                  : _current.backgroundOpacity == 0.5
                      ? 1.0
                      : 0.0;
              _updateOverlay(_current.copyWith(
                backgroundOpacity: nextOpacity,
                backgroundColor: _current.backgroundColor ?? Colors.black,
              ));
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _current.backgroundOpacity > 0
                      ? Colors.blueAccent
                      : Colors.transparent,
                ),
              ),
              child: const Icon(Icons.format_color_fill, color: Colors.white60, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // COLOR PICKER
  // ═══════════════════════════════════════════════════════

  Widget _buildColorPicker() {
    const colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = _current.color == color;
          return GestureDetector(
            onTap: () => _updateOverlay(_current.copyWith(color: color)),
            child: Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.white24,
                  width: isSelected ? 2.5 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // FONT PICKER DIALOG
  // ═══════════════════════════════════════════════════════

  void _showFontPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => FontPicker(
        selectedFont: _current.fontFamily,
        onFontSelected: (font) {
          _updateOverlay(_current.copyWith(fontFamily: font));
          Navigator.pop(ctx);
        },
      ),
    );
  }
}
