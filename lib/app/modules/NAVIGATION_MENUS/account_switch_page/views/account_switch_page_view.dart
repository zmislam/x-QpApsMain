import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/constants/app_assets.dart';

import '../controllers/account_switch_page_controller.dart';

class AccountSwitchPageView extends GetView<AccountSwitchPageController> {
  const AccountSwitchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.goToHomeTabWithDelay();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Container(
            height: size.height * .8,
            width: size.width * .8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(AppAssets.SWITCHING_ANIMATION,width: 120,height: 120),
                  Text('Switching Account...'.tr)
                ],
              ),
            ),
          ),
        ));
  }
}
