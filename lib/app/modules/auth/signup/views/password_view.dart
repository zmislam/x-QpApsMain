import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../../../extension/num.dart';

import '../../../../components/button.dart';
import '../../../../components/text_form_field.dart';
import '../../../../config/constants/app_constant.dart';
import '../../../../utils/url_utils.dart';
import '../../../../utils/validator.dart';
import '../controllers/signup_controller.dart';

class PasswordView extends GetView<SignupController> {
    PasswordView({Key? key}) : super(key: key);
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
              child: Text('Password'.tr,
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
              SizedBox(
                height: Get.height * 0.05,
              ),
                Text('Enter your Password'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
                Center(
                child: Text('Password must contain at least one uppercase letter, one lowercase letter, one number, and one symbol.'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Form(
                key: controller.passwordFormKey,
                child: Obx(
                      () => SignUpTextFormField(
                    controller: controller.passwordController,
                    label: 'Password'.tr,
                    obscureText: controller.obscureText.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureText.value = !controller.obscureText.value;
                      },
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: controller.agreeToTermsAndCondition.value,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: PRIMARY_COLOR,
                        onChanged: (value) {
                          controller.agreeToTermsAndCondition.value =
                              value ?? false;
                        }),
                      Text('I have read & agree to the'.tr,
                        style: TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis),
                      SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        UriUtils.launchUrlInBrowser(
                            AppConstant.PRIVACY_POLICY_URL);
                      },
                      child:   Text('Privacy Policy'.tr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              20.h,
              Padding(
                padding:   EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: controller.signUp,
                        text: 'Next'.tr,
                      ),
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
