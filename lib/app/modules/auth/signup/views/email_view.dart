import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../components/text_form_field.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class EmailView extends GetView<SignupController> {
    EmailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child:   Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
              Center(
              child: Text('Email address'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
      ),
      body: Container(
        height: Get.height,
        color: Colors.white,
        padding:   EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
                Divider(height: 1),
                SizedBox(height: 40),
                Text('Enter your Email address'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                SizedBox(
                height: 30,
              ),
                Center(
                child: Text('Enter the email address where you can be reached.\nNo one else will see this on your profile'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Form(
                key: controller.emailFormKey,
                child: SignUpTextFormField(
                  controller: controller.emailController,
                  label: 'Email address'.tr,
                  validationText: 'Email address is required.',
                  validator: (value) {
                    if (!value!.isEmail) {
                      return 'Enter valid email';
                    }
                    else {
                      return null;
                    }
                  },

                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Padding(
                padding:   EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                          onPressed: () {
                            if (controller.emailFormKey.currentState!
                                .validate()) {
                                  controller.sendOtp();
                              Get.toNamed(Routes.OTP);
                            }
                          },
                          text: 'Next'.tr),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
