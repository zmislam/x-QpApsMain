// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/edit_profile/popup_component.dart';
import 'package:quantum_possibilities_flutter/app/extension/date_time_extension.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import 'package:quantum_possibilities_flutter/app/models/user_work_place.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/controller/about_controller.dart';
import 'package:quantum_possibilities_flutter/app/routes/app_pages.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

// ignore: must_be_immutable
class UserWorkPlacesTile extends StatelessWidget {
  UserWorkPlacesTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final UserWorkPlaceModel model;
  final String? workIcon;

  AboutController aboutController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: PRIMARY_COLOR,
              ),
              height: 60,
              width: 60,
              child: model.org_name != null
                  ? Center(
                      child: (model.org_name?.isNotEmpty ?? false)
                          ? Text(
                              model.org_name?.substring(0, 1).toUpperCase() ??
                                  '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : const SizedBox(),
                    )
                  : const Icon(
                      Icons.business_center,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    (model.org_name ?? '').capitalizeFirstOfEach,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                      visible:
                          model.designation?.isNotEmpty ?? false ? true : false,
                      child: Text(
                        (model.designation ?? '').capitalizeFirstOfEach,
                      )),
                  if (model.from_date != null)
                    Row(
                      children: [
                        Visibility(
                          visible: model.from_date?.isNotEmpty ?? false
                              ? true
                              : false,
                          child: Flexible(
                            child: Text(model.from_date
                                    ?.split('T')[0]
                                    .toWorkPlaceDuration() ??
                                ''),
                          ),
                        ),
                        Visibility(
                            visible: model.from_date?.isNotEmpty ??
                                    false || model.to_date == null
                                ? true
                                : false,
                            child: Text(' - '.tr)),
                        Flexible(
                          child: Text(
                            model.to_date != null
                                ? model.to_date
                                        ?.split('T')[0]
                                        .toWorkPlaceDuration() ??
                                    ''
                                : 'Present',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
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
                EditProfilePopUpMenu(
                  onTapDelete: () {
                    aboutController.onTapDeleteWorkPlacePost(model.id ?? '');
                  },
                  onTapEdit: () {
                    Get.toNamed(Routes.ADD_WORK_PLACE, arguments: model);
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
