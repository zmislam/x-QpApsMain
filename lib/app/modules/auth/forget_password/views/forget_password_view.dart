import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../../../extension/num.dart';
import '../../../../components/button.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/forget_pass_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
    ForgetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
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
                Text('Reset Your Password'.tr,
                style: TextStyle(
                    fontSize: 20,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold),
              ),
              15.h,
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('Enter your email for the verification process, \nwe will send a 4-digit code to your email.'.tr,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              20.h,
              Padding(
                padding:   EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  decoration:   InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Your User E-Mail'.tr,
                  ),
                  onChanged: (value) {
                    controller.email.value = value.toString();
                  },
                ),
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
                            controller.requestForgetPassword();
                          },
                          text: 'Continue'.tr),
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
                    style:   TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                        TextSpan(text: 'Don’t you have an account?'.tr),
                      TextSpan(
                        text: 'Register'.tr,
                        style:   TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offNamed(Routes.SIGNUP);
                          },
                      ),
                        TextSpan(
                          text: '— it’s really simple and you can start enjoying all the benefits!'.tr),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
