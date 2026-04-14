import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A/B Thumbnail Selector — upload 2 cover options for split testing.
class AbThumbnailSelector extends StatelessWidget {
  final File? thumbnailA;
  final File? thumbnailB;
  final ValueChanged<File> onSelectA;
  final ValueChanged<File> onSelectB;
  final VoidCallback onClear;

  const AbThumbnailSelector({
    super.key,
    this.thumbnailA,
    this.thumbnailB,
    required this.onSelectA,
    required this.onSelectB,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.science_outlined, size: 16, color: Colors.blue),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'A/B Test — Upload 2 thumbnails to test which performs better',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Thumbnail A
            Expanded(
              child: _ThumbnailSlot(
                label: 'A',
                file: thumbnailA,
                onSelect: onSelectA,
              ),
            ),
            const SizedBox(width: 12),
            // Thumbnail B
            Expanded(
              child: _ThumbnailSlot(
                label: 'B',
                file: thumbnailB,
                onSelect: onSelectB,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThumbnailSlot extends StatelessWidget {
  final String label;
  final File? file;
  final ValueChanged<File> onSelect;

  const _ThumbnailSlot({
    required this.label,
    this.file,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: file != null ? Colors.blue : Colors.grey[700]!,
              width: file != null ? 2 : 1,
            ),
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(file!, fit: BoxFit.cover),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(label,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate,
                        color: Colors.white38, size: 32),
                    const SizedBox(height: 4),
                    Text('Option $label',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1920,
      imageQuality: 90,
    );
    if (picked != null) {
      onSelect(File(picked.path));
    }
  }
}
