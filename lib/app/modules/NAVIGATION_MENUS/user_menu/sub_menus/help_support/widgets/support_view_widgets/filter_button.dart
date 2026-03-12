import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../controllers/help_support_controller.dart';
import 'filter_bottomsheet.dart';


class FilterButtonWidget extends StatelessWidget {
  final HelpSupportController controller ;
  const FilterButtonWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.bottomSheet( 
        backgroundColor: Theme.of(context).colorScheme.surface,
        FilterBottomSheet(controller:controller ,)),
      child: const Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: Image(
          height: 26,
          width: 24,
          image: AssetImage(AppAssets.HELP_FILTER_ICON),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
