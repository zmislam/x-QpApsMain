import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../components/edit_profile/popup_component.dart';
import '../../../../../../../../components/user_profile/contact_info_tile.dart';
import '../../../../../../../../components/user_profile/educational_workplace_tile.dart';
import '../../../../../../../../components/user_profile/email_info_tile.dart';
import '../../../../../../../../components/user_profile/language_tile.dart';
import '../../../../../../../../components/user_profile/place_lived_home_town_tile.dart';
import '../../../../../../../../components/user_profile/place_lived_present_town_tile.dart';
import '../../../../../../../../components/user_profile/user_workplaces_tile.dart';
import '../../../../../../../../components/user_profile/website_tile.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../models/educational_work_place.dart';
import '../../../../../../../../models/email_list_model.dart';
import '../../../../../../../../models/language.dart';
import '../../../../../../../../models/phone_list_model.dart';
import '../../../../../../../../models/profile_model.dart';
import '../../../../../../../../models/user_work_place.dart';
import '../../../../../../../../models/websites.dart';
import '../controller/about_controller.dart';
import '../../../../../../../../routes/app_pages.dart';
import '../../../../../../../../config/constants/color.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getUserALLData();

    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: PRIMARY_GREY_DIVIDER_COLOR,
              height: 2.0,
            ),
          ),
          title: Text('About'.tr,
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  shrinkWrap: true,
                  children: [
                    /* ============================WorkPlace===============================================*/

                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      // ignore: prefer_const_constructors
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Work'.tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint('tapped');
                            },
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.ADD_WORK_PLACE);
                              },
                              child: Row(
                                children: [
                                  Text('Add Workplace'.tr,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: PRIMARY_COLOR),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.add_circle,
                                    color: PRIMARY_COLOR,
                                    size: 19,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.profileModel.value?.userWorkplaces?.length ??
                                0,
                            itemBuilder: (context, index) {
                              UserWorkPlaceModel userWorkPlaceModel = controller
                                      .profileModel
                                      .value
                                      ?.userWorkplaces?[index] ??
                                  UserWorkPlaceModel();
                              return UserWorkPlacesTile(
                                model: userWorkPlaceModel,
                              );
                            }),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================Education===============================================*/

                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Education'.tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.ADD_EDUCATION);
                            },
                            child: Row(
                              children: [
                                Text('Add Education'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: PRIMARY_COLOR),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.add_circle,
                                  color: PRIMARY_COLOR,
                                  size: 19,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // : const SizedBox()
                    // ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: controller.profileModel.value
                                      ?.educationWorkplaces?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return EducationalWorkPlaceTile(
                                    model: controller.profileModel.value?.educationWorkplaces?[index] ??
                                        EducationalWorkPlace()); // Use EducationWorkplace instead
                              }),
                        )),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================Place Lived===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Places Lived'.tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Map<String, dynamic> arguments =
                                  <String, dynamic>{};
                              arguments.addAll({
                                'isEditing': true,
                                'id':
                                    controller.profileModel.value?.home_town ==
                                            null
                                        ? 2
                                        : 1,
                                'model': controller.profileModel.value
                              });
                              Get.toNamed(Routes.EDIT_PLACESLIVED,
                                  arguments: arguments);
                            },
                            child: Visibility(
                              visible:
                                  controller.profileModel.value?.present_town ==
                                              null ||
                                          controller.profileModel.value
                                                  ?.home_town ==
                                              null
                                      ? true
                                      : false,
                              child: Row(
                                children: [
                                  Text(
                                    controller.profileModel.value
                                                    ?.present_town ==
                                                null &&
                                            controller.profileModel.value
                                                    ?.home_town ==
                                                null
                                        ? 'Add Place'
                                        : controller.profileModel.value
                                                    ?.present_town ==
                                                null
                                            ? 'Add Current Place'
                                            : controller.profileModel.value
                                                        ?.home_town ==
                                                    null
                                                ? 'Add Home Town'
                                                : 'Add Place',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: PRIMARY_COLOR),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    Icons.add_circle,
                                    color: PRIMARY_COLOR,
                                    size: 19,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Obx(() => controller.profileModel.value?.present_town !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: PlaceLivedCurrentCityTile(
                                model: controller.profileModel.value ??
                                    ProfileModel()),
                          )
                        : const SizedBox()),
                    Obx(() => controller.profileModel.value?.home_town != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: PlaceLivedHomeTownTile(
                                model: controller.profileModel.value ??
                                    ProfileModel()),
                          )
                        : const SizedBox()),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),

                    /* ============================Contact Info===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact Info'.tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.ADD_CONTACT);
                              debugPrint('Tapped Add Contact');
                            },
                            child: Row(
                              children: [
                                Text('Add Contact'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: PRIMARY_COLOR),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.add_circle,
                                  color: PRIMARY_COLOR,
                                  size: 19,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: controller
                                      .profileModel.value?.phone_list?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return ContactInfoTile(
                                    model: controller.profileModel.value
                                            ?.phone_list?[index] ??
                                        PhoneListModel());
                              }),
                        )),

                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: controller
                                    .profileModel.value?.email_list?.length ??
                                0,
                            itemBuilder: (BuildContext context, int index) {
                              return EmailInfoTile(
                                  model: controller.profileModel.value
                                          ?.email_list?[index] ??
                                      EmailListModel());
                            },
                          ),
                        )),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),

                    /* ============================WebSites===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Website'.tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ADD_WEBSITE);
                              debugPrint('Tapped Add website');
                            },
                            child: Row(
                              children: [
                                Text('Websites and Other links'.tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: PRIMARY_COLOR),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.add_circle,
                                  color: PRIMARY_COLOR,
                                  size: 19,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: controller
                                      .profileModel.value?.websites?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return WebsiteTile(
                                    model: controller.profileModel.value
                                            ?.websites?[index] ??
                                        Websites());
                              }),
                        )),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================Basic Info===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text('Basic Information'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.add_circle,
                            color: PRIMARY_COLOR,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                    /* ++++++++++++++++++++++++++GENDER +++++++++++++++++++++++++*/
                    Container(
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Visibility(
                                      visible: controller.profileModel.value
                                                  ?.gender?.gender_name !=
                                              null
                                          ? true
                                          : false,
                                      child: Text('Gender'.tr)),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  Icon(
                                      controller.profileModel.value?.privacy
                                                  ?.gender ==
                                              'public'
                                          ? Icons.public
                                          : controller.profileModel.value
                                                      ?.privacy?.gender
                                                      .toString() ==
                                                  'friends'
                                              ? Icons.group
                                              : controller.profileModel.value
                                                          ?.privacy?.gender ==
                                                      null
                                                  ? Icons.public
                                                  : Icons.lock,
                                      size: 20,
                                      color: ENABLED_BORDER_COLOR),
                                  EditProfilePopUpMenu(
                                    onTapEdit: () {
                                      Get.toNamed(Routes.EDIT_GENDER,
                                          arguments: {
                                            'gender': controller.profileModel
                                                .value?.gender?.gender_name,
                                            'privacy': controller.profileModel
                                                .value?.privacy?.gender
                                          });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    /*++++++++++++++++++++++++++++++++++++++++++++++++BIRTHDAY++++++++++++++++*/
                    Container(
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
                                      (controller
                                          .profileModel.value?.date_of_birth
                                          .toString()
                                          .split('T')
                                          .first)?.toFormatDateOfBirth()??'',
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
                                            'public'
                                        ? Icons.public
                                        : controller.profileModel.value?.privacy
                                                    ?.dob
                                                    .toString() ==
                                                'friends'
                                            ? Icons.group
                                            : Icons.lock,
                                    size: 20,
                                    color: ENABLED_BORDER_COLOR),
                                EditProfilePopUpMenu(
                                  onTapDelete: () {},
                                  onTapEdit: () {
                                    Get.toNamed(Routes.EDIT_BIRTH_DATE,
                                        arguments: {
                                          'dob': controller
                                              .profileModel.value?.date_of_birth
                                              .toString()
                                              .split('T')
                                              .first,
                                          'privacy': controller
                                              .profileModel.value?.privacy?.dob
                                        });
                                  },
                                )
                              ],
                            ),
                          )),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================Language===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text('Language'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.ADD_LANGUAGE);
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: PRIMARY_COLOR,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.profileModel.value?.language != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: controller.profileModel.value
                                          ?.language?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    return LanguageTile(
                                        model: controller.profileModel.value
                                                ?.language?[index] ??
                                            LanguageModel());
                                  }),
                            )
                          : const SizedBox(),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),

                    /* ============================Bio===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment:
                            controller.profileModel.value?.user_bio != null
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                        children: [
                          Text('Your Bio'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          controller.profileModel.value?.user_bio == null
                              ? const SizedBox()
                              : const SizedBox(),
                          controller.profileModel.value?.user_bio == null
                              ? IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.ADD_BIO, arguments: {
                                      'bio': controller
                                          .profileModel.value?.user_bio,
                                      'privacy': controller
                                          .profileModel.value?.privacy?.user_bio
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle,
                                      color: PRIMARY_COLOR, size: 19))
                              : const SizedBox(),
                          controller.profileModel.value?.user_bio != null
                              ? const Expanded(child: SizedBox())
                              : const SizedBox(),
                          controller.profileModel.value?.user_bio != null
                              ? Icon(
                                  controller.profileModel.value?.privacy
                                              ?.user_bio
                                              .toString()
                                              .toLowerCase() ==
                                          'public'
                                      ? Icons.public
                                      : controller.profileModel.value?.privacy
                                                  ?.user_bio
                                                  .toString()
                                                  .toLowerCase() ==
                                              'friends'
                                          ? Icons.group
                                          : Icons.lock,
                                  size: 20,
                                  color: ENABLED_BORDER_COLOR)
                              : const SizedBox(),
                          controller.profileModel.value?.user_bio != null
                              ? EditProfilePopUpMenu(
                                  onTapEdit: () {
                                    Get.toNamed(Routes.ADD_BIO, arguments: {
                                      'bio': controller
                                          .profileModel.value?.user_bio,
                                      'privacy': controller
                                          .profileModel.value?.privacy?.user_bio
                                    });
                                  },
                                )
                              : const SizedBox(),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.profileModel.value?.user_bio != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Text('${controller.profileModel.value?.user_bio}'.tr,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          : const SizedBox(),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================About You===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('About You'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          controller.profileModel.value?.user_about == null
                              ? const SizedBox()
                              : const SizedBox(),
                          controller.profileModel.value?.user_about == null
                              ? IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.ADD_ABOUTYOURSELF,
                                        arguments: {
                                          'aboutyou': controller
                                              .profileModel.value?.user_about,
                                          'privacy': controller.profileModel
                                              .value?.privacy?.about
                                        });
                                  },
                                  icon: const Icon(Icons.add_circle,
                                      color: PRIMARY_COLOR, size: 19))
                              : const SizedBox(),
                          const Expanded(child: SizedBox()),
                          controller.profileModel.value?.user_about != null
                              ? Icon(
                                  controller.profileModel.value?.privacy?.about
                                              .toString()
                                              .toLowerCase() ==
                                          'public'
                                      ? Icons.public
                                      : controller.profileModel.value?.privacy
                                                  ?.about
                                                  .toString()
                                                  .toLowerCase() ==
                                              'friends'
                                          ? Icons.group
                                          : Icons.lock,
                                  size: 20,
                                  color: ENABLED_BORDER_COLOR)
                              : const SizedBox(),
                          controller.profileModel.value?.user_about != null
                              ? EditProfilePopUpMenu(
                                  onTapEdit: () {
                                    Get.toNamed(Routes.ADD_ABOUTYOURSELF,
                                        arguments: {
                                          'aboutyou': controller
                                              .profileModel.value?.user_about,
                                          'privacy': controller.profileModel
                                              .value?.privacy?.about
                                        });
                                  },
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.profileModel.value?.user_about != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Text('${controller.profileModel.value?.user_about}'.tr,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          : const SizedBox(),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================RelationShip===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text('Relationship'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          controller.profileModel.value?.relation_status == null
                              ? const SizedBox()
                              : const SizedBox(),
                          controller.profileModel.value?.relation_status == null
                              ? IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.EDIT_RELATIONSHIP,
                                        arguments: {
                                          'relationship': controller
                                              .profileModel
                                              .value
                                              ?.relation_status,
                                          'privacy': controller.profileModel
                                              .value?.privacy?.relationship
                                        });
                                  },
                                  icon: const Icon(Icons.add_circle,
                                      color: PRIMARY_COLOR, size: 19))
                              : const SizedBox(),
                        ],
                      ),
                    ),

                    controller.profileModel.value?.relation_status != null
                        ? Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  controller.profileModel.value
                                              ?.relation_status !=
                                          null
                                      ? Image.asset(
                                          AppAssets.USER_HEART_ICON,
                                          width: 40,
                                          height: 40,
                                          color: PRIMARY_COLOR,
                                        )
                                      : const SizedBox(),
                                  controller.profileModel.value
                                              ?.relation_status !=
                                          null
                                      ? const SizedBox(width: 20)
                                      : const SizedBox(),
                                  Obx(() => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          controller.profileModel.value
                                                      ?.relation_status !=
                                                  null
                                              ? Text('Relationship'.tr)
                                              : const SizedBox(),
                                        ],
                                      )),
                                  controller.profileModel.value
                                              ?.relation_status !=
                                          null
                                      ? const Expanded(child: SizedBox())
                                      : const SizedBox(),
                                  controller.profileModel.value
                                              ?.relation_status !=
                                          null
                                      ? Icon(
                                          controller.profileModel.value?.privacy
                                                      ?.relationship
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'public'
                                              ? Icons.public
                                              : controller
                                                          .profileModel
                                                          .value
                                                          ?.privacy
                                                          ?.relationship
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'friends'
                                                  ? Icons.group
                                                  : Icons.lock,
                                          size: 20,
                                          color: ENABLED_BORDER_COLOR)
                                      : const SizedBox(),
                                  controller.profileModel.value
                                              ?.relation_status !=
                                          null
                                      ? EditProfilePopUpMenu(
                                          onTapEdit: () {
                                            Get.toNamed(
                                                Routes.EDIT_RELATIONSHIP,
                                                arguments: {
                                                  'relationship': controller
                                                      .profileModel
                                                      .value
                                                      ?.relation_status,
                                                  'privacy': controller
                                                      .profileModel
                                                      .value
                                                      ?.privacy
                                                      ?.relationship
                                                });
                                          },
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    /* ============================NickName===============================================*/
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Text('Nickname'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: PRIMARY_COLOR),
                          ),
                          controller.profileModel.value?.user_nickname == null
                              ? const SizedBox()
                              : const SizedBox(),
                          controller.profileModel.value?.user_nickname == null
                              ? IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.EDIT_NICKNAME,
                                        arguments: {
                                          'nickname': controller.profileModel
                                              .value?.user_nickname,
                                          'privacy': controller.profileModel
                                              .value?.privacy?.nickname
                                        });
                                  },
                                  icon: const Icon(Icons.add_circle,
                                      color: PRIMARY_COLOR, size: 19))
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    controller.profileModel.value?.user_nickname != null
                        ? Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.profileModel.value
                                                    ?.user_nickname ??
                                                '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('Nickname'.tr),
                                        ],
                                      )),
                                  const Expanded(child: SizedBox()),
                                  Icon(
                                      controller.profileModel.value?.privacy
                                                  ?.nickname
                                                  .toString()
                                                  .toLowerCase() ==
                                              'public'
                                          ? Icons.public
                                          : controller.profileModel.value
                                                      ?.privacy?.nickname
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'friends'
                                              ? Icons.group
                                              : Icons.lock,
                                      size: 20,
                                      color: ENABLED_BORDER_COLOR),
                                  EditProfilePopUpMenu(
                                    onTapEdit: () {
                                      Get.toNamed(Routes.EDIT_NICKNAME,
                                          arguments: {
                                            'nickname': controller.profileModel
                                                .value?.user_nickname,
                                            'privacy': controller.profileModel
                                                .value?.privacy?.nickname
                                          });
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 20)
                  ],
                ),
        ));
  }
}
