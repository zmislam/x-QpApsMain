import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/reel_filter_model.dart';

/// Green screen background picker — select image/video from gallery
/// or a solid color as chroma-key replacement background.
class GreenScreenPicker extends StatefulWidget {
  final GreenScreenConfig? currentConfig;
  final ValueChanged<GreenScreenConfig?> onConfigChanged;

  const GreenScreenPicker({
    super.key,
    this.currentConfig,
    required this.onConfigChanged,
  });

  @override
  State<GreenScreenPicker> createState() => _GreenScreenPickerState();
}

class _GreenScreenPickerState extends State<GreenScreenPicker> {
  GreenScreenConfig _config = const GreenScreenConfig();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.currentConfig != null) {
      _config = widget.currentConfig!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 360),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Green Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (widget.currentConfig != null)
                      TextButton(
                        onPressed: () => widget.onConfigChanged(null),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                    TextButton(
                      onPressed: () => widget.onConfigChanged(_config),
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Source type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _SourceChip(
                  icon: Icons.image,
                  label: 'Image',
                  isSelected: _config.source == GreenScreenSource.image,
                  onTap: () => _selectSource(GreenScreenSource.image),
                ),
                const SizedBox(width: 8),
                _SourceChip(
                  icon: Icons.videocam,
                  label: 'Video',
                  isSelected: _config.source == GreenScreenSource.video,
                  onTap: () => _selectSource(GreenScreenSource.video),
                ),
                const SizedBox(width: 8),
                _SourceChip(
                  icon: Icons.color_lens,
                  label: 'Color',
                  isSelected: _config.source == GreenScreenSource.color,
                  onTap: () => _selectSource(GreenScreenSource.color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Preview / gallery picker area
          if (_config.source == GreenScreenSource.color) _buildColorPicker(),
          if (_config.source != GreenScreenSource.color) _buildMediaPicker(),
          const SizedBox(height: 12),
          // Sensitivity slider
          _buildSlider(
            label: 'Sensitivity',
            value: _config.sensitivity,
            onChanged: (v) {
              setState(() => _config = _config.copyWith(sensitivity: v));
            },
          ),
          // Smoothing slider
          _buildSlider(
            label: 'Smoothing',
            value: _config.smoothing,
            onChanged: (v) {
              setState(() => _config = _config.copyWith(smoothing: v));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMediaPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _pickMedia,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: _config.mediaPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_config.mediaPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.white38),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _config = _config.copyWith(mediaPath: '');
                            });
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _config.source == GreenScreenSource.image
                          ? Icons.add_photo_alternate
                          : Icons.video_library,
                      color: Colors.white38,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to select ${_config.source == GreenScreenSource.image ? 'image' : 'video'}',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.white,
      Colors.black,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map((color) {
          final isSelected = _config.backgroundColor == color.value;
          return GestureDetector(
            onTap: () {
              setState(() {
                _config = _config.copyWith(backgroundColor: color.value);
              });
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white24,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.greenAccent,
                inactiveTrackColor: Colors.white12,
                thumbColor: Colors.greenAccent,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value,
                min: 0.0,
                max: 1.0,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${(value * 100).round()}%',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  void _selectSource(GreenScreenSource source) {
    setState(() {
      _config = GreenScreenConfig(
        source: source,
        sensitivity: _config.sensitivity,
        smoothing: _config.smoothing,
      );
    });
  }

  Future<void> _pickMedia() async {
    try {
      if (_config.source == GreenScreenSource.image) {
        final file = await _picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          setState(() {
            _config = _config.copyWith(mediaPath: file.path);
          });
        }
      } else {
        final file = await _picker.pickVideo(source: ImageSource.gallery);
        if (file != null) {
          setState(() {
            _config = _config.copyWith(mediaPath: file.path);
          });
        }
      }
    } catch (_) {
      // Silently handle permission denied
    }
  }
}

class _SourceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.greenAccent : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.greenAccent : Colors.white54),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.greenAccent : Colors.white54,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
