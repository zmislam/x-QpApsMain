
import 'package:flutter/material.dart';

import '../../../../../../../components/help_messeage_title/message_tile.dart';
import '../../../../../../../models/help_reply_model.dart';

class MessageItem extends StatelessWidget {
  final HelpReplyModel message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MessageTile(messageModel: message),
    );
  }
}
