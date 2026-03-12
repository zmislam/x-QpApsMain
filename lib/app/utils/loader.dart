import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../config/constants/color.dart';

void showLoader() {
  EasyLoading.show(status: 'Loading...'.tr);
}

void configLoader() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = PRIMARY_COLOR
    ..textColor = PRIMARY_COLOR;
}

void dismissLoader() {
  EasyLoading.dismiss();
}
