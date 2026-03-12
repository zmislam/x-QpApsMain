import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/other_user_profile/other_contact_info_tile.dart';
import '../../../../../components/other_user_profile/other_educational_workplace_tile.dart';
import '../../../../../components/other_user_profile/other_email_info_tile.dart';
import '../../../../../components/other_user_profile/other_language_tile.dart';
import '../../../../../components/other_user_profile/other_place_lived_home_town_tile.dart';
import '../../../../../components/other_user_profile/other_place_lived_present_town_tile.dart';
import '../../../../../components/other_user_profile/other_user_workplace_tile.dart';
import '../../../../../components/other_user_profile/other_website_tile.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../models/educational_work_place.dart';
import '../../../../../models/email_list_model.dart';
import '../../../../../models/language.dart';
import '../../../../../models/phone_list_model.dart';
import '../../../../../models/profile_model.dart';
import '../../../../../models/user_work_place.dart';
import '../../../../../models/websites.dart';
import '../controller/other_profile_controller.dart';

class OtherProfileDetailView extends GetView<OthersProfileController> {
  const OtherProfileDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About'.tr,
          ),
          // backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              Obx(() =>
              controller.profileModel.value?.userWorkplaces?.length != 0
                  ? Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Work Place'.tr,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
                  : const SizedBox()),
              /*============================================OTHER Workplace============================================*/
              Obx(
                    () => controller.profileModel.value?.userWorkplaces?.length != 0
                    ? ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller
                        .profileModel.value?.userWorkplaces?.length,
                    itemBuilder: (context, index) {
                      UserWorkPlaceModel userWorkPlaceModel = controller
                          .profileModel.value?.userWorkplaces?[index] ??
                          UserWorkPlaceModel();
                      return OtherUserWorkPlacesTile(
                        model: userWorkPlaceModel,
                      );
                    })
                    : const SizedBox(),
              ),
              Obx(() =>
              controller.profileModel.value?.userWorkplaces?.length != 0
                  ? const Divider(
                color: Colors.grey,
                thickness: 1,
              )
                  : const SizedBox()),
              /*============================================OTHER Education============================================*/

              Obx(() => controller.profileModel.value?.educationWorkplaces
                  ?.isNotEmpty ??
                  false
                  ? Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Education'.tr,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
                  : const SizedBox()),
              Obx(
                    () => controller.profileModel.value?.educationWorkplaces
                    ?.isNotEmpty ??
                    false
                    ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: controller
                        .profileModel.value?.educationWorkplaces?.length,
                    itemBuilder: (context, index) {
                      return OtherEducationalWorkPlaceTile(
                          model: controller.profileModel.value
                              ?.educationWorkplaces?[index] ??
                              EducationalWorkPlace());
                    })
                    : const SizedBox(),
              ),
              Obx(() => controller.profileModel.value?.educationWorkplaces
                  ?.isNotEmpty ??
                  false
                  ? const Divider(
                color: Colors.grey,
                thickness: 1,
              )
                  : const SizedBox()),
              /*============================================OTHER Places Lived============================================*/

              Obx(() => controller.profileModel.value?.present_town != null ||
                  controller.profileModel.value?.home_town != null
                  ? Visibility(
                visible: controller.profileModel.value?.present_town ==
                    null &&
                    controller.profileModel.value?.home_town == null
                    ? false
                    : true,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: Text('Places Lived'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  : const SizedBox()),
              Obx(() => controller.profileModel.value?.present_town != null
                  ? Visibility(
                visible: controller
                    .profileModel.value?.privacy?.present_town ==
                    'only_me'
                    ? false
                    : true,
                child: OtherPlaceLivedCurrentCityTile(
                    model:
                    controller.profileModel.value ?? ProfileModel()),
              )
                  : const SizedBox()),
              Obx(() => controller.profileModel.value?.home_town != null
                  ? Visibility(
                visible:
                controller.profileModel.value?.privacy?.home_town ==
                    'only_me'
                    ? false
                    : true,
                child: OtherPlaceLivedHomeTownTile(
                    model:
                    controller.profileModel.value ?? ProfileModel()),
              )
                  : const SizedBox()),
              Visibility(
                visible: controller.profileModel.value?.present_town == null &&
                    controller.profileModel.value?.home_town == null
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /*============================================OTHER Contact Info============================================*/
              Obx(
                    () => controller.profileModel.value?.phone_list?.length != 0 ||
                    controller.profileModel.value?.email_list?.length != 0
                    ? Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: Text('Contact Info'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : const SizedBox(),
              ),
              Obx(() => controller.profileModel.value?.phone_list?.length ==
                  0 &&
                  controller.profileModel.value?.email_list?.length == 0
                  ? const SizedBox()
                  : ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount:
                  controller.profileModel.value?.phone_list?.length ??
                      0,
                  itemBuilder: (context, index) {
                    return OhterContactInfoTile(
                        model: controller
                            .profileModel.value?.phone_list?[index] ??
                            PhoneListModel());
                  })),
              Obx(() => controller.profileModel.value?.phone_list == null &&
                  controller.profileModel.value?.email_list == null
                  ? const SizedBox()
                  : ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount:
                controller.profileModel.value?.email_list?.length ??
                    0,
                itemBuilder: (BuildContext context, int index) {
                  return OtherEmailInfoTile(
                      model: controller
                          .profileModel.value?.email_list?[index] ??
                          EmailListModel());
                },
              )),
              Visibility(
                visible: controller.profileModel.value?.phone_list?.length ==
                    0 &&
                    controller.profileModel.value?.email_list?.length == 0
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /*============================================OTHER Website============================================*/
              controller.profileModel.value?.websites?.length != 0
                  ? Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: Text('Website'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR),
                ),
              )
                  : const SizedBox(),
              Obx(() => controller.profileModel.value?.websites?.length != 0
                  ? ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount:
                  controller.profileModel.value?.websites?.length ?? 0,
                  itemBuilder: (context, index) {
                    return OtherWebsiteTile(
                        model: controller
                            .profileModel.value?.websites?[index] ??
                            Websites());
                  })
                  : const SizedBox()),
              controller.profileModel.value?.websites?.length != 0
                  ? const Divider(
                color: Colors.grey,
                thickness: 1,
              )
                  : const SizedBox(),
              /* ============================OTHER Basic Info===============================================*/
              Visibility(
                visible: controller.profileModel.value?.privacy?.gender ==
                    'only_me' &&
                    controller.profileModel.value?.privacy?.dob == 'only_me'
                    ? false
                    : true,
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text('Basic Information'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              /* ++++++++++++++++++++++++++GENDER +++++++++++++++++++++++++*/
              Visibility(
                visible:
                controller.profileModel.value?.privacy?.gender == 'only_me'
                    ? false
                    : true,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Obx(
                        () => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppAssets.USER_GENDER_ICON,
                            width: 40,
                            height: 40,
                            color: PRIMARY_COLOR,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.profileModel.value?.gender
                                    ?.gender_name ??
                                    '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Visibility(
                                  visible: controller.profileModel.value?.gender
                                      ?.gender_name !=
                                      null
                                      ? true
                                      : false,
                                  child: Text('Gender'.tr)),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Icon(
                              controller.profileModel.value?.privacy?.gender
                                  .toString() ==
                                  'public' ||
                                  controller.profileModel.value?.privacy
                                      ?.gender ==
                                      null
                                  ? Icons.public
                                  : controller.profileModel.value?.privacy
                                  ?.gender
                                  .toString() ==
                                  'friends'
                                  ? Icons.group
                                  : Icons.lock,
                              size: 20,
                              color: ENABLED_BORDER_COLOR),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              /*++++++++++++++++++++++++++++++++++++++++++++++++BIRTHDAY++++++++++++++++*/
              Visibility(
                visible:
                controller.profileModel.value?.privacy?.dob == 'only_me'
                    ? false
                    : true,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Obx(() => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.USER_BIRTHDAY_ICON,
                          width: 40,
                          height: 40,
                          color: PRIMARY_COLOR,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (controller.profileModel.value?.date_of_birth
                                  .toString()
                                  .split('T')
                                  .first)
                                  ?.toFormatDateOfBirth() ??
                                  '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('Birthdate'.tr),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Icon(
                            controller.profileModel.value?.privacy?.dob
                                .toString() ==
                                'public' ||
                                controller.profileModel.value?.privacy
                                    ?.dob ==
                                    null
                                ? Icons.public
                                : controller.profileModel.value?.privacy
                                ?.dob
                                .toString() ==
                                'friends'
                                ? Icons.group
                                : Icons.lock,
                            size: 20,
                            color: ENABLED_BORDER_COLOR),
                      ],
                    ),
                  )),
                ),
              ),
              Visibility(
                visible: controller.profileModel.value?.privacy?.gender ==
                    'only_me' &&
                    controller.profileModel.value?.privacy?.dob == 'only_me'
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /* ============================Language===============================================*/
              Obx(() =>
              (controller.profileModel.value?.language?.isNotEmpty ?? false)
                  ? Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: Text('Language'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : const SizedBox()),
              Obx(
                    () => (controller.profileModel.value?.language?.isNotEmpty ??
                    false)
                    ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount:
                    controller.profileModel.value?.language?.length ??
                        0,
                    itemBuilder: (context, index) {
                      return OtherLanguageTile(
                          model: controller
                              .profileModel.value?.language?[index] ??
                              LanguageModel());
                    })
                    : const SizedBox(),
              ),
              Obx(() => controller.profileModel.value?.language?.length != 0
                  ? const Divider(
                color: Colors.grey,
                thickness: 1,
              )
                  : const SizedBox()),

              /* ============================Bio===============================================*/
              Visibility(
                visible: controller.profileModel.value?.privacy?.user_bio ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.user_bio == null
                    ? false
                    : true,
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Text('Your Bio'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                          controller.profileModel.value?.privacy?.user_bio
                              .toString()
                              .toLowerCase() ==
                              'public'
                              ? Icons.public
                              : controller.profileModel.value?.privacy?.user_bio
                              .toString()
                              .toLowerCase() ==
                              'friends'
                              ? Icons.group
                              : Icons.lock,
                          size: 20,
                          color: ENABLED_BORDER_COLOR),
                    ],
                  ),
                ),
              ),
              Obx(
                    () => controller.profileModel.value?.user_bio != null
                    ? Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child:
                  Text('${controller.profileModel.value?.user_bio}'.tr,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                )
                    : const SizedBox(),
              ),
              Visibility(
                visible: controller.profileModel.value?.privacy?.user_bio
                    .toString()
                    .toLowerCase() ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.user_bio == null
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /* ============================About You===============================================*/
              Visibility(
                visible: controller.profileModel.value?.privacy?.about ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.about == null
                    ? false
                    : true,
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Text('About You'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                          controller.profileModel.value?.privacy?.about
                              .toString()
                              .toLowerCase() ==
                              'public'
                              ? Icons.public
                              : controller.profileModel.value?.privacy?.about
                              .toString()
                              .toLowerCase() ==
                              'friends'
                              ? Icons.group
                              : Icons.lock,
                          size: 20,
                          color: ENABLED_BORDER_COLOR),
                    ],
                  ),
                ),
              ),
              Obx(
                    () => controller.profileModel.value?.user_about != null
                    ? Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child:
                  Text('${controller.profileModel.value?.user_about}'.tr,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                )
                    : const SizedBox(),
              ),
              Visibility(
                visible: controller.profileModel.value?.privacy?.about ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.about == null
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /* ============================RelationShip===============================================*/
              controller.profileModel.value?.relation_status != null
                  ? Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: Text('Relationship'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : const SizedBox(),
              controller.profileModel.value?.relation_status != null
                  ? Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppAssets.USER_HEART_ICON,
                      width: 40,
                      height: 40,
                      color: PRIMARY_COLOR,
                    ),
                    const SizedBox(width: 20),
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.profileModel.value
                              ?.relation_status ??
                              '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('Relationship'.tr),
                      ],
                    )),
                    const Expanded(child: SizedBox()),
                    Icon(
                        controller.profileModel.value?.privacy
                            ?.relationship
                            .toString()
                            .toLowerCase() ==
                            'public' ||
                            controller.profileModel.value?.privacy
                                ?.relationship ==
                                null
                            ? Icons.public
                            : controller.profileModel.value?.privacy
                            ?.relationship
                            .toString()
                            .toLowerCase() ==
                            'friends'
                            ? Icons.group
                            : Icons.lock,
                        size: 20,
                        color: ENABLED_BORDER_COLOR),
                  ],
                ),
              )
                  : const SizedBox(),
              Visibility(
                visible: controller.profileModel.value?.relation_status == null
                    ? false
                    : true,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              /* ============================NickName===============================================*/
              Visibility(
                visible: controller.profileModel.value?.privacy?.nickname
                    .toString()
                    .toLowerCase() ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.nickname
                        .toString()
                        .toLowerCase() ==
                        'only me' ||
                    controller.profileModel.value?.privacy?.nickname == null
                    ? false
                    : true,
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text('Nickname'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.profileModel.value?.privacy?.nickname
                    .toString()
                    .toLowerCase() ==
                    'only_me' ||
                    controller.profileModel.value?.privacy?.nickname
                        .toString()
                        .toLowerCase() ==
                        'only me' ||
                    controller.profileModel.value?.privacy?.nickname == null
                    ? false
                    : true,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppAssets.USER_NICKNAME_ICON,
                        width: 40,
                        height: 40,
                        color: PRIMARY_COLOR,
                      ),
                      const SizedBox(width: 20),
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.profileModel.value?.user_nickname ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Nickname'.tr),
                        ],
                      )),
                      const Expanded(child: SizedBox()),
                      Icon(
                          controller.profileModel.value?.privacy?.nickname
                              .toString()
                              .toLowerCase() ==
                              'public'
                              ? Icons.public
                              : controller.profileModel.value?.privacy?.nickname
                              .toString()
                              .toLowerCase() ==
                              'friends'
                              ? Icons.group
                              : Icons.lock,
                          size: 20,
                          color: ENABLED_BORDER_COLOR),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}
