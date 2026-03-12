import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../extension/date_time_extension.dart';
import '../../controllers/help_support_controller.dart';
import 'default_image.dart';

class TicketHeader extends StatelessWidget {
  final HelpSupportController controller;

  const TicketHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: _headerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.helpReplyModel.value.topics.toString().toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Text(
              controller.helpReplyModel.value.description.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 5),
            _buildAttachments(),
            const SizedBox(height: 5),
            Text(
              (controller.helpReplyModel.value.createdAt
                  .toString()
                  .toDetailFormatDateTime()),
              style: const TextStyle(color: PRIMARY_COLOR),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _headerDecoration() => BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        border: const Border(left: BorderSide(color: PRIMARY_COLOR, width: 5)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      );

  Widget _buildAttachments() {
    final attachments = controller.helpReplyModel.value.photos ?? [];
    return attachments.isNotEmpty
        ? Image(
            height: 120,
            image: NetworkImage(attachments.first.formatedHelpSupportUrl),
            errorBuilder: (_, __, ___) => const DefaultImage(),
          )
        : const SizedBox();
  }
}
