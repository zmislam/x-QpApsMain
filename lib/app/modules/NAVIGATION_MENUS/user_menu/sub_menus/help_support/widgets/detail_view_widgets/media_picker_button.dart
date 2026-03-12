
import 'package:flutter/material.dart';

import '../../../../../../../config/constants/app_assets.dart';
import '../../controllers/help_support_controller.dart';

class MediaPickerButton extends StatelessWidget {
  final HelpSupportController controller;

  const MediaPickerButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13.0),
      child: InkWell(
        onTap: controller.pickFiles,
        child: const Image(
          height: 20,
          width: 20,
          image: AssetImage(AppAssets.PICK_MEDIA_ICON),
        ),
      ),
    );
  }
}
