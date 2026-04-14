import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Thumbnail picker — choose a frame from video or upload custom image.
class ThumbnailPicker extends StatelessWidget {
  final ValueChanged<double> onFrameSelected;
  final ValueChanged<File> onCustomSelected;

  const ThumbnailPicker({
    super.key,
    required this.onFrameSelected,
    required this.onCustomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frame selector — horizontal scrubber of video frames
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              final position = index / 10.0;
              return GestureDetector(
                onTap: () => onFrameSelected(position),
                child: Container(
                  width: 56,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: Text(
                      '${(position * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Upload custom thumbnail
        TextButton.icon(
          onPressed: () => _pickCustomThumbnail(context),
          icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
          label: const Text('Add from Camera Roll'),
        ),
      ],
    );
  }

  Future<void> _pickCustomThumbnail(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1920,
      imageQuality: 90,
    );
    if (picked != null) {
      onCustomSelected(File(picked.path));
    }
  }
}
