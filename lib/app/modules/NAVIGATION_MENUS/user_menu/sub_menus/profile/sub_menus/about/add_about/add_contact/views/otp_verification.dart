import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../components/button.dart';
import '../controllers/add_contact_controller.dart';
import '../../../../../../../../../../config/constants/color.dart';



class OtpForContactView extends GetView<AddContactController> {
  const OtpForContactView({Key? key}) : super(key: key);
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
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            Center(
              child: Text('OTP Verification'.tr,
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
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(height: 1),
              const SizedBox(height: 40),
              Text('Verification Code'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    Text('Enter the verification code we have sent '.tr,
                      textAlign: TextAlign.center,
                    ),
                    Text(' to your email address'.tr,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Form(
                key: controller.emailFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    OtpTextField(
                      cursorColor: PRIMARY_COLOR,
                      focusedBorderColor: PRIMARY_COLOR,
                      // enabledBorderColor: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      fieldWidth: 50,
                      numberOfFields: 4,
                      borderColor: PRIMARY_COLOR,
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {
                        // controller.otp.value = code;
                      },
                      onSubmit: (String verificationCode) {
                        controller.otp.value = verificationCode;
                        controller.verifyOtp(verificationCode);
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => controller.resendEnabled.value
                          ? TextButton(
                              onPressed: () {
                                controller.startOtpResendTimer();
                                // controller.resendOtp(newEmail);
                              },
                              child: Text('Resend'.tr,
                                style: TextStyle(
                                  color: Color(0xFF00BF6D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Text('Resend in ${controller.remainingSeconds.value} seconds'.tr,
                              style: TextStyle(color: Colors.grey),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                          onPressed: () {
                            if (controller.otpFormKey.currentState!
                                .validate()) {
                              controller.verifyOtp(controller.otp.value);
                             
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
