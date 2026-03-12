import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../data/post_local_data.dart';
import '../components/multiselect_dropdown_widget.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../controllers/create_group_controller.dart';

class CreateGroupView extends GetView<CreateGroupController> {
  const CreateGroupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.nameController.clear();
    controller.addressController.clear();
    controller.descriptionController.clear();
    controller.zipCodeController.clear();
    controller.coverfiles.value.clear();
    controller.profilefiles.value.clear();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Create Group',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(' Group Name'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.nameController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Group Name '.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      } else if (value.length > 50) {
                        return 'Group name should not exceed 50 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Group Description'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Group Description '.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group description';
                      } else if (value.length > 400) {
                        return 'Group description should not exceed 400 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(' Privacy'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  PrimaryDropDownField(
                      hint: 'Privacy',
                      list: groupPrivacyList,
                      onChanged: (changedValue) {
                        controller.privacyDropdownValue.value =
                            changedValue ?? '';
                      }),
                  const SizedBox(height: 20),
                  Text('Contact Information'.tr,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),
                  Text('Address'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Enter Your Address  '.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      } else if (value.length > 200) {
                        return 'Address should not exceed 200 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text('City'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.locationController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Enter Your city Here '.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      } else if (value.length > 30) {
                        return 'City should not exceed 30 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Zip Code'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.zipCodeController,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: FOCUSED_BORDER,
                      hintText: ' Zip Code '.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a zip code';
                      } else if (value.length > 10) {
                        return 'Zip Code mustnot 10 digits long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Invite Friends'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => CustomMultiSelectDropdownWidget(
                      items: controller.friendList.value,
                      hint: 'Select Friends',
                      onSelectionChanged: (selectedUsernames) {
                        controller.selectedUsernames.value = selectedUsernames;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Group Photo'.tr,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Visibility(
                      visible: controller.coverPhotoError.value.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          controller.coverPhotoError.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }),

                  Obx(
                    () => Visibility(
                      visible:
                          controller.coverfiles.value.isNotEmpty ? true : false,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.coverfiles.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            XFile xFile = controller.coverfiles.value[index];

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    image: FileImage(
                                      File(xFile.path),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      controller.coverfiles.value
                                          .removeAt(index);
                                      controller.coverfiles.refresh();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          controller.pickCoverFiles();
                        },
                        style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(2, 2)),
                                side: BorderSide(color: Colors.grey))),
                        child: Text('Add Your Cover Photo'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: PRIMARY_COLOR),
                        )),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Receiving notifications for  your group profile '.tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      CupertinoSwitch(
                          value: controller.switchValue.value,
                          activeTrackColor: PRIMARY_COLOR,
                          onChanged: (bool? changedValue) {
                            controller.switchValue.value =
                                changedValue ?? false;
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Emails for marketing and promotions related to your group'.tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      CupertinoSwitch(
                          value: controller.switchValue.value,
                          activeTrackColor: PRIMARY_COLOR,
                          onChanged: (bool? changedValue) {
                            controller.switchValue.value =
                                changedValue ?? false;
                          })
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Obx(
                  //   () => Container(
                  //     height: 50,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         color: controller.isSaveButtonEnabled.value == true
                  //             ? Colors.grey
                  //             : PRIMARY_COLOR,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: TextButton(
                  //       onPressed: () {
                  //         if (controller.formKey.currentState?.validate() ??
                  //             false) {
                  //           if (controller.coverfiles.value.isEmpty) {
                  //             controller.coverPhotoError.value =
                  //                 'Please add a cover photo';
                  //           } else {
                  //             controller.coverPhotoError.value = '';
                  //             controller.createGroup().whenComplete(
                  //                   () => Get.toNamed(Routes.MY_GROUPS),
                  //                 );
                  //           }
                  //         }
                  //       },
                  //       child: Text(
                  //         'Create Group',
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Obx(
                    () => Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: controller.isSaveButtonEnabled.value == true
                              ? Colors.grey
                              : PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            if (controller.coverfiles.value.isEmpty) {
                              controller.coverPhotoError.value =
                                  'Please add a cover photo';
                            } else {
                              controller.coverPhotoError.value = '';
                              controller.createGroup().whenComplete(
                                    () => Get.toNamed(Routes.MY_GROUPS),
                                  );
                            }
                          }
                        },
                        child: Text('Create Group'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
