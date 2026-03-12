import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../controllers/help_support_controller.dart';
import 'ticket_card_widget.dart';

class HelpListWidget extends StatelessWidget {
  const HelpListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpSupportController>();

    return Obx(() {
      if (controller.helpSupportList.value.isEmpty) {
        return const EmptyStateWidget();
      }
      return ListView.builder(
        itemCount: controller.helpSupportList.value.length,
        padding: const EdgeInsets.only(bottom: 20),
        itemBuilder: (context, index) => TicketCardWidget(
          model: controller.helpSupportList.value[index],
        ),
      );
    });
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.NO_TICKET_ICON,
        fit: BoxFit.contain,
        width: 200,
        height: 200,
      ),
    );
  }
}
