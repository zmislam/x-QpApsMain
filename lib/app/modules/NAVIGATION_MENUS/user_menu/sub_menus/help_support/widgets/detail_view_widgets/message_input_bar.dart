import 'package:flutter/material.dart';

import '../../controllers/help_support_controller.dart';
import 'media_picker_button.dart';
import 'send_button.dart';
import 'package:get/get.dart';

class MessageInputBar extends StatelessWidget {
  final HelpSupportController controller;
  final String ticketId;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.messageInputController,
            decoration: InputDecoration(
              hintText: 'Type your message here...'.tr,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(width: 5),
        MediaPickerButton(controller: controller),
        SendButton(controller: controller, ticketId: ticketId),
      ],
    );
  }
}
