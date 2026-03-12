import 'package:flutter/material.dart';

import '../../controllers/help_support_controller.dart';
import 'help_message_list.dart';
import 'ticket_header.dart';

class MessageContent extends StatelessWidget {
  final HelpSupportController controller;
  final String ticketId;

  const MessageContent({super.key, required this.controller, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TicketHeader(controller: controller),
          const SizedBox(height: 10),
          HelpMessageList(controller: controller),
        ],
      ),
    );
  }
}

