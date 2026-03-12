import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../extension/num.dart';

import '../../../../components/button.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/forget_pass_controller.dart';

class SetforgetpassView extends GetView<ForgetPasswordController> {
    SetforgetpassView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      // Obx(() =>

      Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      50.h,
                        Image(
                        height: 120,
                        image: AssetImage(AppAssets.APP_LOGO),
                      ),
                      10.h,
                        Text('Quantum Possibilities'.tr,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      15.h,
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create New Password'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      20.h,
                      Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          return TextFormField(
                            obscureText: !controller.isVisible.value,
                            decoration: InputDecoration(
                              hintText: 'New Password'.tr,
                              border: InputBorder.none,
                              errorText: controller.passwordError.value.isEmpty
                                  ? null
                                  : controller.passwordError.value, // 👈 dynamic error text
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.isVisible.value = !controller.isVisible.value;
                                },
                                icon: Icon(
                                  controller.isVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                  controller.isVisible.value ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.password.value = value;
                              controller.validatePassword(); // 👈 live validation
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          return TextFormField(
                            obscureText: !controller.isVisible2.value,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password'.tr,
                              border: InputBorder.none,
                              errorText: controller.confirmPassError.value.isEmpty
                                  ? null
                                  : controller.confirmPassError.value, // 👈 dynamic error
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.isVisible2.value = !controller.isVisible2.value;
                                },
                                icon: Icon(
                                  controller.isVisible2.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                  controller.isVisible2.value ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.confirmPass.value = value;
                              controller.validateConfirmPassword(); // 👈 live validation
                            },
                          );
                        }),
                      ),
                      30.h,
                      Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                verticalPadding: 15,
                                onPressed: () {
                                  // 👇 Trigger validation manually
                                  controller.validatePassword();
                                  controller.validateConfirmPassword();

                                  if (controller.passwordError.value.isNotEmpty) {
                                    // show password rule error
                                    Get.snackbar(
                                      'Invalid Password',
                                      controller.passwordError.value,
                                      colorText: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  if (controller.confirmPassError.value.isNotEmpty) {
                                    // show confirm mismatch error
                                    Get.snackbar(
                                      'Password Mismatch',
                                      controller.confirmPassError.value,
                                      colorText: Colors.white,
                                      backgroundColor: Colors.orangeAccent,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  // ✅ All good — call API
                                  controller.setNewPassword();
                                },
                                text: 'Update Password'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.h,
                        Text('Or'.tr),
                      10.h,
                      Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style:   TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: [
                                TextSpan(
                                  text: 'Don’t you have an account? '.tr),
                              TextSpan(
                                text: 'Register'.tr,
                                style:   TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offAll(Routes.SIGNUP);
                                  },
                              ),
                                TextSpan(
                                  text: ' — it’s really simple and you can start enjoying all the benefits!'.tr),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}
