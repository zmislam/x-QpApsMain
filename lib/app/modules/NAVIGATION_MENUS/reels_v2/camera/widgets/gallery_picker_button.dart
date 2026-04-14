import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Gallery picker button — opens gallery for multi-select (photos + videos).
/// Shows thumbnail of last selected file.
class GalleryPickerButton extends StatelessWidget {
  final ReelsCameraController controller;

  const GalleryPickerButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.selectedGalleryFiles.length;

      return GestureDetector(
        onTap: () => controller.pickFromGallery(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white30),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count > 0 ? 'Gallery ($count)' : 'Gallery',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    });
  }
}
