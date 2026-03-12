
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../components/text_form_field.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';
import '../controllers/signup_controller.dart';

class NameView extends GetView<SignupController> {
    NameView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.white,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child:   Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
              Text('Create account'.tr,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              Divider(height: 1),
              SizedBox(height: 40),
              Center(
              child: Text(
                "What's your name?".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
              SizedBox(height: 10),
            Text('Enter the name you use in real life.'.tr,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
              SizedBox(height: 20),
            Padding(
              padding:   EdgeInsets.all(32),
              child: Form(
                key: controller.nameFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: SignUpTextFormField(
                        controller: controller.firstNameController,
                        label: 'First Name'.tr,
                        validationText: 'First name is required',
                      ),
                    ),
                      SizedBox(width: 20),
                    Expanded(
                      child: SignUpTextFormField(
                        controller: controller.lastNameController,
                        label: 'Last Name'.tr,
                        validationText: 'First name is required',
                      ),
                    ),
                  ],
                ),
              ),
            ),
              SizedBox(height: 20),
              Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Profile Photo'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
              SizedBox(height: 20),
            Obx(
              () => controller.selectedProfileImage.value == null
                  ? InkWell(
                      onTap: () {
                        controller.onTapPickProfileImage();
                      },
                      child: Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 20),
                        child: DottedBorder(
                          options: RectDottedBorderOptions(
                            color: PRIMARY_COLOR,
                            strokeWidth: 2,
                            dashPattern:   [8, 4],
                          ),
                          child: Container(
                            width: double.infinity,
                            // margin: EdgeInsets.symmetric(horizontal: 10),
                            // padding: EdgeInsets.symmetric(horizontal: 10),

                            height: 200,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/group_profile/file_upload.png',
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                                  SizedBox(height: 16),
                                  Text('Click to Upload Photo'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Visibility(
                      visible: controller.selectedProfileImage.value != null,
                      replacement:   SizedBox.shrink(),
                      child: Container(
                        width: double.infinity,
                        padding:   EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Display the selected image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: controller.selectedProfileImage.value !=
                                      null
                                  ? Image.file(
                                      controller.selectedProfileImage.value!,
                                      height:300,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    )
                                  : null, // If no image is selected, show nothing
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: // Close icon to remove the image
                                  IconButton(
                                onPressed: () {
                                  controller.removeProfileImage();
                                },
                                icon:   Icon(Icons.close,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
              SizedBox(height: 50),
            Padding(
              padding:   EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        // Validate the form and the profile picture
                        if (controller.nameFormKey.currentState!.validate() &&
                            controller.validateProfilePic() == null) {
                          Get.toNamed(Routes.BIRTHDAY);
                        } else {
                          // Show validation message for profile picture
                          if (controller.validateProfilePic() != null) {
                            Get.snackbar(
                              'Validation Error'.tr,
                              controller.validateProfilePic()!,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      text: 'Next'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
