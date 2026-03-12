import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../components/button.dart';

import '../config/constants/color.dart';

void showAppExitDialog() {
  Get.dialog(AlertDialog(
    contentPadding: const EdgeInsets.all(0),
    content: Container(
      height: 200,
      decoration: BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(10),
      ),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Exit QP'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(color: Theme.of(Get.context!).cardTheme.color),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('Are you sure, you want to exit?'.tr,
                      style: Theme.of(Get.context!).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('No'.tr,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text('Yes'.tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  ));
}

Future<void> showShareClosingDialog({required String title}) async {
  await Get.dialog(Dialog(
    child: Container(
      height: 240,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Share $title'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Your ${title.toLowerCase()} isn\'t shared yet. Do you want to save or discard it?',
          ),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  horizontalPadding: 10,
                  verticalPadding: 10,
                  onPressed: () => Get.back(canPop: true, closeOverlays: true),
                  text: 'Discard $title'.tr,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  horizontalPadding: 12,
                  verticalPadding: 10,
                  onPressed: () => Get.back(canPop: false),
                  text: 'Keep Editing'.tr,
                ),
              )
            ],
          ),
        ],
      ),
    ),
  ));
}
