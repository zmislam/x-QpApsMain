import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/app_assets.dart';
import '../controllers/settings_privacy_controller.dart';
import '../../../../config/constants/color.dart';

class ChangePasswordView extends GetView<SettingsPrivacyController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          // backgroundColor: Colors.white,
          title: Text('Change Password'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Password'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      color: Theme.of(context).cardTheme.color),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        Text('Current Password'.tr,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // Current/Old password
                        TextFormField(
                          controller: controller.oldPasswordController.value,
                          obscureText: controller.obscureOldPassword.value,
                          decoration: InputDecoration(
                            // labelText: 'Current Password'.tr,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureOldPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  controller.toggleOldPasswordVisibility(),
                            ),
                          ),
                          onChanged: (value) {
                            controller.oldPassword.value = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('New Password'.tr,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // New password
                        TextFormField(
                          controller: controller.newPasswordController.value,
                          obscureText: controller.obscureNewPassword.value,
                          decoration: InputDecoration(
                            // labelText: 'New Password'.tr,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureNewPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  controller.toggleNewPasswordVisibility(),
                            ),
                          ),
                          onChanged: (value) {
                            controller.newPassword.value = value;
                            controller.validatePasswordConditions();
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Confirm Password'.tr,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Confirm password
                        TextFormField(
                          controller:
                              controller.confirmPasswordController.value,
                          obscureText: controller.obscureConfirmPassword.value,
                          decoration: InputDecoration(
                            // labelText: 'Confirm Password'.tr,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureConfirmPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  controller.toggleConfirmPasswordVisibility(),
                            ),
                          ),
                          onChanged: (value) {
                            controller.confirmPassword.value = value;
                            controller.validatePasswordConditions();
                          },
                        ),
                        const SizedBox(height: 30),
                        controller.isPasswordTooShort.value
                            ? Row(
                                children: [
                                  Image.asset(
                                    AppAssets.CHECK_ICON,
                                    width: 20,
                                    height: 20,
                                    // color: PRIMARY_COLOR,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text('Minimum 8 characters.'.tr,
                                    style: TextStyle(
                                      color: Color(0xFF4C4A53),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        controller.isPasswordInvalid.value
                            ? Row(
                                children: [
                                  Image.asset(
                                    AppAssets.CHECK_ICON,
                                    width: 20,
                                    height: 20,
                                    // color: PRIMARY_COLOR,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text('Must include uppercase, lowercase, number, and special character.'.tr,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFF4C4A53),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        controller.isPasswordMismatch.value
                            ? Row(
                                children: [
                                  Image.asset(
                                    AppAssets.CHECK_ICON,
                                    width: 20,
                                    height: 20,
                                    // color: PRIMARY_COLOR,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Password doesn\'t macth the new password.',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFF4C4A53),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        // Submit button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Reset Button
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: PRIMARY_COLOR, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onPressed: () {
                                    controller.resetPasswordData();
                                  },
                                  child: Text('Reset Field'.tr,
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Submit Button
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onPressed: () {
                                    if (controller.validatePasswordForm()) {
                                      controller.onTapChangePasswordPost();
                                    }
                                  },
                                  child: Text('Submit'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )

                        // ElevatedButton(
                        //   onPressed: () {
                        //     if (controller.validatePasswordForm()) {
                        //       controller.onTapChangePasswordPost();
                        //     }
                        //   },
                        //   child: Text('Change Password'.tr),
                        //   style: ElevatedButton.styleFrom(
                        //     padding: const EdgeInsets.symmetric(vertical: 15),
                        //     minimumSize: const Size(double.infinity, 50),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
