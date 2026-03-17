import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../components/text_form_field.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';
import '../../../../services/versionCheckerService.dart';
import '../../../../utils/Localization/languageSelection.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
    const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionCheckerService().checkAppVersion();
    });
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'.tr),
        actions: [
            LanguageSelector(),
            SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:   EdgeInsets.all(20),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                children: [
                    SizedBox(height: 40),
                    Image(
                    height: 128,
                    image: AssetImage(AppAssets.APP_LOGO),
                  ),
                    SizedBox(height: 40),
                    Text('Welcome to the first decentralised and centralised Social Network in the world'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SfProDisplay',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                    SizedBox(height: 20),
                    Text('Login here'.tr,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SfProDisplay',
                    ),
                  ),
                    SizedBox(height: 40),
                  LoginTextFormField(
                    controller: controller.userIdController,
                    obscureText: false,
                    label: 'Email'.tr,
                    validationText: 'Email is required'.tr,
                  ),
                    SizedBox(height: 10),
                  Obx(
                    () => LoginTextFormField(
                      controller: controller.passwordController,
                      label: 'Password'.tr,
                      obscureText: controller.obscureText.value,
                      suffixIconButton: IconButton(
                        onPressed: () {
                          controller.obscureText.value =
                              !controller.obscureText.value;
                        },
                        icon: Icon(
                          controller.obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      validationText: 'Password is required'.tr,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButton(
                        onPressed: () {
                          Get.toNamed(Routes.FORGET_PASS);
                        },
                        text: 'Forgot your password?'.tr,
                        backgroundColor: Colors.transparent,
                        textColor: PRIMARY_COLOR,
                        horizontalPadding: 0,
                        fontSize: 16,
                        verticalPadding: 20,
                      ),
                    ],
                  ),
                    SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            onPressed: () {
                              debugPrint('function call before ');
                              controller.onPressedLogin();
                            },
                            text: 'Sign in'.tr),
                      ),
                    ],
                  ),
                  PrimaryButton(
                    onPressed: () {
                      Get.toNamed(Routes.SIGNUP);
                    },
                    text: 'Create new account'.tr,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey.shade800,
                    fontSize: 18,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
