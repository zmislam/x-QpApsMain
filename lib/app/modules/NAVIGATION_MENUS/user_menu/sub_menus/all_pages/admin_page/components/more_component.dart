import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_page_more_options_view/admin_page_invites.dart';

import '../../../../../../../config/constants/color.dart';
import '../admin_page_more_options_view/admin_page_followers.dart';
import '../controller/admin_page_controller.dart';


class PageMoreComponent extends StatefulWidget {
  final AdminPageController controller;
  final VoidCallback onClose;

  const PageMoreComponent({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<PageMoreComponent> createState() => _PageMoreComponentState();
}

class _PageMoreComponentState extends State<PageMoreComponent> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Followers'.tr, style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: () {
              Get.back();
              Get.to(() => const AdminPageFollowers());

              // widget.onClose();
            },
          ),
          const Divider(color: PRIMARY_COLOR,thickness: 0.5,),
          ListTile(
            title: Text('Invites'.tr, style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: () {
              Get.back();

              Get.to(() => const AdminPageInvites());

              // widget.onClose();
            },
          ),
        ],
      ),
    );
  }
}
