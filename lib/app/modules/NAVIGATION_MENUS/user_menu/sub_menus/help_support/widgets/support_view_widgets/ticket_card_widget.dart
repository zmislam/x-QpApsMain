import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/user_profile/help_center_card.dart';
import '../../../../../../../models/help_model.dart';
import '../../views/help_support_details_view.dart';

class TicketCardWidget extends StatelessWidget {
  final HelpModel model;

  const TicketCardWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () => Get.to(() => HelpSupportDetailsView(model.id.toString())),
        child: HelpCenterCard(model: model),
      ),
    );
  }
}