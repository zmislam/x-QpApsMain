import 'package:flutter/material.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../controllers/help_support_controller.dart';
import 'filter_options.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  final HelpSupportController controller ;
  const FilterBottomSheet({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25),
          FilterOptionWidget(
            icon: AppAssets.ALL_HELP_ICON,
            label: 'All Ticket'.tr,
            status: '', controller: controller,
          ),
          FilterOptionWidget(
            icon: AppAssets.NEW_HELP_ICON,
            label: 'New Ticket'.tr,
            status: 'pending',
             controller: controller,
          ),
          FilterOptionWidget(
            icon: AppAssets.SOLVED_HELP_ICON,
            label: 'On Going'.tr,
            status: 'processing',
             controller: controller,
          ),
          FilterOptionWidget(
            icon: AppAssets.PROCESSING_HELP_ICON,
            label: 'Resolved'.tr,
            status: 'solved',
             controller: controller,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
