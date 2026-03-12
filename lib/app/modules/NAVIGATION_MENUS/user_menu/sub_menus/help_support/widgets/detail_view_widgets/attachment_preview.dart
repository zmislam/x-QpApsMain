import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/help_support_controller.dart';
import 'attachment_thumnail.dart';

class AttachmentsPreview extends StatelessWidget {
  final HelpSupportController controller;

  const AttachmentsPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.xfiles.value.isNotEmpty,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.xfiles.value.length,
                itemBuilder: (context, index) => AttachmentThumbnail(
                  xFile: controller.xfiles.value[index],
                  onRemove: () => controller.xfiles.value.removeAt(index),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
