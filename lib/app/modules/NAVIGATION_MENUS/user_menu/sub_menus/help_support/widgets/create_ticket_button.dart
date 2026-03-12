import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/create_ticket_view.dart';
import '../../../../../../config/constants/app_assets.dart';

class CreateTicketButton extends StatelessWidget {
  const CreateTicketButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const CreateTicketView()),
      child: const Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Image(
          height: 20,
          width: 20,
          image: AssetImage(AppAssets.HELP_FORM_ICON),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
