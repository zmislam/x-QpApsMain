import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
    SignupView({Key? key}) : super(key: key);
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
              child: Text('Create account'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
              Divider(),
            Image.asset('assets/other/Illustration.png'),
              SizedBox(height: 120),
              Text('Join Quantum possibilities'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
              SizedBox(height: 20),
            Text('We’ll help you\nto create a new account in a few easy steps.'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
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
                          Get.toNamed(Routes.NAME);
                        },
                        text: 'Next'.tr),
                  ),
                ],
              ),
            ),
              SizedBox(height: 50),
            InkWell(
              onTap: () {
                Get.back();
              },     
              child:   Text('Already have an account?'.tr,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PRIMARY_COLOR),
              ),
            )
          ],
        ),
      ),
    );
  }
}
