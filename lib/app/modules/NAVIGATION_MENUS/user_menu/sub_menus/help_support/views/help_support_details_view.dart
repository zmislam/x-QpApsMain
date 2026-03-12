// File name: help_support_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/custom_app_bar/custom_app_bar.dart';
import '../controllers/help_support_controller.dart';
import '../widgets/detail_view_widgets/attachment_preview.dart';
import '../widgets/detail_view_widgets/message_content.dart';
import '../widgets/detail_view_widgets/message_input_bar.dart';

class HelpSupportDetailsView extends StatelessWidget {
  final String ticketId;
  final HelpSupportController controller = Get.find();

  HelpSupportDetailsView(this.ticketId, {super.key});

  @override
  Widget build(BuildContext context) {
    controller.getHelpSupportMessageList(ticketId.toString());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ticket #$ticketId'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const Divider(color: Colors.grey),
            Expanded(
              child: MessageContent(controller: controller, ticketId: ticketId),
            ),
            AttachmentsPreview(controller: controller),
            MessageInputBar(controller: controller, ticketId: ticketId),
          ],
        ),
      ),
    );
  }
}





