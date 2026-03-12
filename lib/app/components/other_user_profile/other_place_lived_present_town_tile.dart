// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/models/profile_model.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

class OtherPlaceLivedCurrentCityTile extends StatelessWidget {
  const OtherPlaceLivedCurrentCityTile({
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
                    model.present_town?.capitalizeFirst ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                      visible: model.present_town != null ? true : false,
                      child: Text('Current City'.tr)),
                ],
              ),
            ),

            Icon(
                model.privacy.toString() == 'public' ||
                    model.privacy == null
                    ? Icons.public
                    : model.privacy?.present_town.toString() == 'friends'
                        ? Icons.group
                        : Icons.lock,
                size: 20,
                color: ENABLED_BORDER_COLOR),
            //     EditProfilePopUpMenu(

            //       onTapEdit: () {
            //          Map<String,dynamic>arguments = Map<String,dynamic>();
            //         arguments.addAll({'id':1,'model':model});
            //         Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: arguments);

            //       }
            //       ,
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
