import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../config/constants/color.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.navigate();
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              'assets/logo/user_app_logo.png',
              height: 52,
              width: 57,
            ),

            // ! REPLACED THR GIF AS IT HAD A FIXED WHITE BG! AND
            // ! WAS CREATING CONFLICT WITH DARK THEME
            const SizedBox(height: 10),
            LoadingAnimationWidget.progressiveDots(color: PRIMARY_COLOR, size: 40),
            // Image.asset(
            //   'assets/other/loading.gif',
            //   height: 52,
            //   width: 70,
            // ),
          ],
        ), //Text('SplashView is working'.tr,style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
