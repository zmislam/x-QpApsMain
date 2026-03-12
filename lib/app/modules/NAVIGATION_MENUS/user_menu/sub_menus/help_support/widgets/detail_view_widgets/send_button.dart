import 'package:flutter/material.dart';
import '../../../../../../../config/constants/app_assets.dart';

import '../../controllers/help_support_controller.dart';

class SendButton extends StatelessWidget {
  final HelpSupportController controller;
  final String ticketId;

  const SendButton({
    super.key,
    required this.controller,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await controller
            .replyTicket(controller.helpReplyModel.value.id.toString());
        await controller.getHelpSupportMessageList(ticketId);
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Image(
          height: 20,
          width: 20,
          image: AssetImage(AppAssets.SEND_MESSEAGE_ICON),
        ),
      ),
    );
  }
}
