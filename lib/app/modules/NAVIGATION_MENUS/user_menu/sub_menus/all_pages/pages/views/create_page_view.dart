import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../components/dropdown.dart';
import '../../../../../../../models/location_model.dart';
import '../../../../../reels/sub_menu/boost_reels/components/custom_dropdown_bottomsheet.dart';
import '../controllers/pages_controller.dart';
import '../../../../../../../config/constants/color.dart';

class CreatePageView extends StatefulWidget {
  const CreatePageView({super.key});

  @override
  State<CreatePageView> createState() => _CreatePageViewState();
}

class _CreatePageViewState extends State<CreatePageView> {
  @override
  Widget build(BuildContext context) {
    PagesController pagesController = Get.put(PagesController());
    pagesController.nameController.clear();
    pagesController.bioController.clear();
    pagesController.zipCodeController.clear();
    pagesController.coverfiles.value.clear();
    pagesController.profilefiles.value.clear();
    pagesController.descriptionController.clear();

    List<String> categoryList = [
      'Business',
      'Entertainment',
      'Education',
      'Health',
      'Sports',
      'Technology',
      'Travel',
      "Ads manager's",
      'Others',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: pagesController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Create Page',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' Page Name'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                        controller: pagesController.nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: FOCUSED_BORDER,
                          hintText: ' Page Name '.tr,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a page name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Category'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PrimaryDropDownField(
                          hint: 'Choose Category',
                          list: categoryList,
                          onChanged: (changed) {
                            pagesController.selectedCategory = changed;
                          }),
                      const SizedBox(height: 20),
                      Text('Page Description'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200),
                        ],
                        controller: pagesController.descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: FOCUSED_BORDER,
                          hintText: ' Page Description '.tr,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a page description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Page Bio'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        controller: pagesController.bioController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: FOCUSED_BORDER,
                          hintText: ' Page Bio '.tr,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a page bio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Location'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => SearchAbleDropdownBottomSheet<AllLocation>(
                          heightFactor: 0.70,
                          title: 'Select Location'.tr,
                          selectedItem: pagesController.selectedLocation.value,
                          asyncItems: pagesController.getFutureLocation,
                          onItemSelected: (value) {
                            pagesController.selectedLocation.value = value;
                            pagesController.onCLocationChanged = pagesController
                                    .selectedLocation.value?.locationName ??
                                '';
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Zip Code'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: pagesController.zipCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: FOCUSED_BORDER,
                          hintText: ' Zip Code '.tr,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a zip code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('Page Photo'.tr,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () {
                              pagesController.pickProfilesFiles();
                            },
                            style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(2, 2)),
                                    side: BorderSide(color: Colors.grey))),
                            child: Text('Add Your Profile Picture'.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: PRIMARY_COLOR),
                            )),
                      ),
                      Obx(
                        () => Visibility(
                          visible:
                              pagesController.profilefiles.value.isNotEmpty,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            decoration: const BoxDecoration(),
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  pagesController.profilefiles.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                XFile xFile =
                                    pagesController.profilefiles.value[index];

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
                                          pagesController.profilefiles.value
                                              .removeAt(index);
                                          pagesController.profilefiles
                                              .refresh();
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
                              pagesController.pickCoverFiles();
                            },
                            style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(2, 2)),
                                    side: BorderSide(color: Colors.grey))),
                            child: Text('Add Your Cover Photo'.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: PRIMARY_COLOR),
                            )),
                      ),
                      Obx(
                        () => Visibility(
                          visible: pagesController.coverfiles.value.isNotEmpty,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            decoration: const BoxDecoration(),
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  pagesController.coverfiles.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                XFile xFile =
                                    pagesController.coverfiles.value[index];

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
                                          pagesController.coverfiles.value
                                              .removeAt(index);
                                          pagesController.coverfiles.refresh();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Receiving notifications for  your profile page'.tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          CupertinoSwitch(
                              value: pagesController.switchValue.value,
                              activeTrackColor: PRIMARY_COLOR,
                              onChanged: (bool? changedValue) {
                                pagesController.switchValue.value =
                                    changedValue ?? false;
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Emails for marketing and promotions related to your page'.tr,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            CupertinoSwitch(
                                value: pagesController.switchValue.value,
                                activeTrackColor: PRIMARY_COLOR,
                                onChanged: (bool? changedValue) {
                                  pagesController.switchValue.value =
                                      changedValue ?? false;
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color:
                              pagesController.isSaveButtonEnabled.value == true
                                  ? Colors.grey
                                  : PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          if (pagesController.formKey.currentState
                                  ?.validate() ??
                              false) {
                            pagesController.createPage();
                          }
                        },
                        child: Text('Create Page'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
