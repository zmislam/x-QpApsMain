// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/models/email_list_model.dart';


import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:get/get.dart';

class OtherEmailInfoTile extends StatelessWidget {
  const OtherEmailInfoTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final EmailListModel model;
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
            SizedBox(
                child: Image.asset(
              AppAssets.USER_EMAIL_ICON,
              width: 40,
              height: 40,
              color: PRIMARY_COLOR,
            )),
            const SizedBox(width: 20),
            Visibility(
              visible: model.email != null ? true : false,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Email'.tr),
                  ],
                ),
              ),
            ),
            // Row(
            //   children: [
                Icon(
                    model.privacy.toString() == 'public'
                        ? Icons.public
                        : model.privacy.toString() == 'friends'
                            ? Icons.group
                            : Icons.lock,
                    size: 20,
                    color: ENABLED_BORDER_COLOR),
            //     // EditProfilePopUpMenu(
            //     //   onTapDelete: () {
            //     //     aboutController.onTapDeleteEmailPost(model.id ?? '');
            //     //   },
            //     //   onTapEdit: () {
            //     //     Map<String, dynamic>? arguments = Map<String, dynamic>();
            //     //     arguments.addAll({'id': 2, 'model': model});
            //     //     Get.toNamed(Routes.ADD_CONTACT, arguments: arguments);
            //     //   },
            //     // )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
