import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/string/string_image_path.dart';
import '../data/login_creadential.dart';
import '../modules/NAVIGATION_MENUS/friend/controllers/friend_controller.dart';
import '../models/friend.dart';
import '../config/constants/color.dart';

import 'image.dart';

class FriendCard extends StatelessWidget {
  FriendCard({
    super.key,
    required this.model,
  });

  FriendController friendController = Get.put(FriendController());

  RxString character = 'Spam'.obs;

  final FriendModel model;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0.0,
      leading: Container(
        height: Get.width * 0.30,
        margin: const EdgeInsets.only(bottom: 5),
        child: RoundCornerNetworkImage(
          imageUrl: (model.friend?.profilePic ?? '').formatedProfileUrl,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.friend?.firstName ?? ''} ${model.friend?.lastName ?? ''}',
                style:
                     TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              PopupMenuButton(
                  padding: const EdgeInsets.only(left: 20, bottom: 15),
                  iconColor: Colors.black,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            Get.dialog(AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              content: Container(
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 200,
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Unfriend A Friend'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Are you sure, you want to unfriend?'.tr,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        foregroundColor:
                                                            PRIMARY_COLOR,
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:  Text('No'.tr,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            PRIMARY_COLOR,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        friendController
                                                            .unfriendFriends(
                                                                '${model.friend?.id}');
                                                        Get.back();
                                                      },
                                                      child:  Text('Yes'.tr),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                          },
                          value: 1,
                          // row has two child icon and text.
                          child:  Text('Unfriend'.tr,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Get.dialog(AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              content: Container(
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 200,
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Block A Friend'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Are you sure, you want to block?'.tr,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        foregroundColor:
                                                            PRIMARY_COLOR,
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:  Text('No'.tr,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            PRIMARY_COLOR,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        if (LoginCredential()
                                                                .getUserData()
                                                                .id ==
                                                            model.friend?.id) {
                                                          friendController
                                                              .blockFriends(
                                                                  '${model.friend?.id}');
                                                        } else if (LoginCredential()
                                                                .getUserData()
                                                                .id ==
                                                            model.friend?.id) {
                                                          friendController
                                                              .blockFriends(
                                                                  '${model.friend?.id}');
                                                        }

                                                        Get.back();
                                                      },
                                                      child:  Text('Yes'.tr),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                          },
                          value: 1,
                          // row has two child icon and text.
                          child:  Text('Block'.tr,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Get.bottomSheet(
                              SizedBox(
                                height: Get.height / 1.8,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child:  Text('Report'.tr,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        children: [
                                          Obx(() => ListTile(
                                                title:  Text('Spam'.tr),
                                                subtitle:  Text('It’s spam or violent'.tr),
                                                leading: Radio<String>(
                                                  value: 'Spam',
                                                  groupValue: character.value,
                                                  onChanged: (String? value) {
                                                    character.value = value!;
                                                    // setState(() {
                                                    //   _character = value;
                                                    // });
                                                  },
                                                ),
                                              )),
                                          Obx(() => ListTile(
                                                title:  Text('False information'.tr),
                                                subtitle:  Text('If someone is in immediate danger'.tr),
                                                leading: Radio<String>(
                                                  value: 'False information',
                                                  groupValue: character.value,
                                                  onChanged: (String? value) {
                                                    character.value = value!;
                                                    // setState(() {
                                                    //   _character = value;
                                                    // });
                                                  },
                                                ),
                                              )),
                                          Obx(() => ListTile(
                                                title:  Text('Nudity'.tr),
                                                subtitle:  Text('It’s Sexual activity or nudity showing genitals'.tr),
                                                leading: Radio<String>(
                                                  value: 'Nudity',
                                                  groupValue: character.value,
                                                  onChanged: (String? value) {
                                                    character.value = value!;
                                                    // setState(() {
                                                    //   _character = value;
                                                    // });
                                                  },
                                                ),
                                              )),
                                          Obx(() => ListTile(
                                                title:  Text('Harassment'.tr),
                                                subtitle:  Text('If any post harassment for you and your friend'.tr),
                                                leading: Radio<String>(
                                                  value: 'Harassment',
                                                  groupValue: character.value,
                                                  onChanged: (String? value) {
                                                    character.value = value!;
                                                    // setState(() {
                                                    //   _character = value;
                                                    // });
                                                  },
                                                ),
                                              )),
                                          Obx(() => ListTile(
                                                title:  Text('Something Else'.tr),
                                                subtitle:  Text('Fraud, scam, violence, hate speech etc. '.tr),
                                                leading: Radio<String>(
                                                  value: 'Something Else',
                                                  groupValue: character.value,
                                                  onChanged: (String? value) {
                                                    character.value = value!;
                                                    // setState(() {
                                                    //   _character = value;
                                                    // });
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50,
                                            width: Get.width / 2,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
                                            child:  Text('Cancel'.tr,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // Get.back();

                                            Get.bottomSheet(
                                              SizedBox(
                                                height: Get.height / 1.8,
                                                width: Get.width,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child:  Text('Report'.tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Text('Description'.tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          height:
                                                              Get.height / 2.9,
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey)),
                                                          child:
                                                               TextField(
                                                            maxLines: 8,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width:
                                                                Get.width / 2,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1)),
                                                            child:  Text('Back'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            width:
                                                                Get.width / 2,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                              color: PRIMARY_COLOR
                                                                  .withValues(
                                                                      alpha:
                                                                          0.7),
                                                            ),
                                                            child:  Text('Report'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // backgroundColor: Colors.white,
                                              isScrollControlled: true,
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                              color: PRIMARY_COLOR.withValues(
                                                  alpha: 0.7),
                                            ),
                                            width: Get.width / 2,
                                            child:  Text('Continue'.tr,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },

                          value: 1,
                          // row has two child icon and text.
                          child:  Text('Report'.tr,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ]),
            ],
          ),
        ],
      ),
    );
  }
}
