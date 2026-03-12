// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/models/profile_model.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

import '../../models/language.dart';
import 'package:get/get.dart';

class OtherLanguageTile extends StatelessWidget {
   const OtherLanguageTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final LanguageModel model;
  final String? workIcon;
  // AboutController aboutController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          AppAssets.USER_LANGUAGE_ICON,
          width: 40,
          height: 40,
          color: PRIMARY_COLOR,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.language ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Language'.tr),
      
            // Row(children: [
            //   Icon(
            //       model.privacy.toString() == 'public'
            //           ? Icons.public
            //           : Icons.lock,
            //       size: 20,
            //       color: ENABLED_BORDER_COLOR),
            //   const SizedBox(width: 5),
            //   Text(model.privacy?.toString().capitalizeFirst ?? '')
            // ])
          ],
        ),
        const Expanded(child: SizedBox()),
        Row(
          children: [
                Icon(
                    model.privacy.toString() == 'public'
                        ? Icons.public
                        : model.privacy.toString() == 'friends'
                            ? Icons.group
                            : Icons.lock,
                    size: 20,
                    color: ENABLED_BORDER_COLOR),
           
          ],
        )
      ],
              ),
            ),
    );
  }
}
