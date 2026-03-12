import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/image.dart';

import '../../controller/create_post_controller.dart';

class MediaFileView extends StatelessWidget {
  MediaFileView({
    super.key,
    required this.mediaUrl,
    required this.onTapRemoveMediaFile,
    this.isClipRect = false,
    required this.index,
  });

  final String mediaUrl;
  final bool isClipRect;
  final int index;
  final VoidCallback onTapRemoveMediaFile;

  final CreatePostController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.xfiles.value.isEmpty) {
        return const SizedBox(); 
      }

      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(isClipRect ? 10 : 0),
            child: PrimaryFileImage(
              filePath: mediaUrl,
              fitImage: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: InkWell(
              onTap: () {
                if (index >= 0 && index < controller.xfiles.value.length) {
                  controller.xfiles.update((val) {
                    val?.removeAt(index);
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
