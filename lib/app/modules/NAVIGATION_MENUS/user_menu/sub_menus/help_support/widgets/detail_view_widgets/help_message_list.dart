import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/help_support_controller.dart';
import 'message_item.dart';

class HelpMessageList extends StatelessWidget {
  final HelpSupportController controller;

  const HelpMessageList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.helpSupportMessageList.value.length,
        itemBuilder: (context, index) => MessageItem(
          message: controller.helpSupportMessageList.value[index],
        ),
      ),
    );
  }
}
