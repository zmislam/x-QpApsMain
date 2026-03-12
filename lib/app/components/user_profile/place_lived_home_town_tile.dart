// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/edit_profile/popup_component.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';

import 'package:quantum_possibilities_flutter/app/models/profile_model.dart';
import 'package:quantum_possibilities_flutter/app/routes/app_pages.dart';

import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

class PlaceLivedHomeTownTile extends StatelessWidget {
  const PlaceLivedHomeTownTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final ProfileModel model;
  final String? workIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.USER_LOCATION_ICON,
              width: 40,
              height: 40,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.home_town?.capitalizeFirst ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                      visible: model.home_town != null ? true : false,
                      child: Text('Home Town'.tr)),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                    model.privacy?.home_town.toString() == 'public'
                        ? Icons.public
                        : model.privacy?.home_town.toString() == 'friends'
                            ? Icons.group
                            : Icons.lock,
                    size: 20,
                    color: ENABLED_BORDER_COLOR),
                EditProfilePopUpMenu(
                  onTapEdit: () {
                    Map<String, dynamic> arguments = <String, dynamic>{};
                    arguments.addAll({'id': 2, 'model': model});
                    Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: arguments);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
