import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/button.dart';
import '../../../routes/app_pages.dart';

class LiveBottomWidget extends StatelessWidget {
  /// text editing controller
  final TextEditingController textEditingController;

  /// field focus node
  final FocusNode focusNode;

  /// tapping on share button
  final void Function() onShareTap;

  /// on field submitted
  final void Function(String)? onFieldSubmitted;

  /// Callback to notify the parent when the bottom widget is toggled
  final VoidCallback? onBottomWidgetToggle;

  /// on stream end done
  final Function streamEndFunction;

  /// share count
  final String? shareCount;

    LiveBottomWidget(
      {super.key,
      required this.textEditingController,
      required this.focusNode,
      required this.onShareTap,
      this.onFieldSubmitted,
      this.shareCount,
      required this.streamEndFunction,
      this.onBottomWidgetToggle});

  @override
  Widget build(BuildContext context) {
    bool messageSend = false;

    return SingleChildScrollView(
      physics:   ClampingScrollPhysics(),
      child: Container(
        width: Get.width,
        padding:
              EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ============================= Middle section ========================
            Expanded(
                child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                //Toggle on  the bottomSheet is Open/Close
                onBottomWidgetToggle?.call();
                Get.bottomSheet(PopScope(
                  canPop: true,
                  onPopInvokedWithResult: (didPop, result) {
                    // Notify the parent that the bottom widget is being closed
                    onBottomWidgetToggle?.call();
                  },
                  child: Container(
                    width: Get.width,
                    padding:   EdgeInsetsDirectional.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration:   BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12))),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (value) {
                              if (!messageSend) {
                                messageSend = true;
                                onFieldSubmitted!(value);
                                Get.back();
                              }
                            },
                            onEditingComplete: () {
                              // Handle the back button on the keyboard
                              onBottomWidgetToggle?.call();
                              if (!messageSend) {
                                messageSend = true;
                                onFieldSubmitted!(textEditingController.text);
                                Get.back();
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Type Comment'.tr,
                                hintStyle: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                                contentPadding:
                                      EdgeInsetsDirectional.symmetric(
                                        vertical: 6, horizontal: 12),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                            .withValues(alpha: 0.4)),
                                    borderRadius: BorderRadius.circular(24)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                            .withValues(alpha: 0.4)),
                                    borderRadius: BorderRadius.circular(24)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                          BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(24))),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (!messageSend) {
                              messageSend = true;
                              onFieldSubmitted!(textEditingController.text);
                              Get.back();
                            }
                          },
                          icon:   Icon(
                            Icons.send,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                )).then((e) {
                  // Notify the parent that the bottom widget is being closed
                  onBottomWidgetToggle?.call();
                  focusNode.unfocus();
                  messageSend = false;
                });

                Future.delayed(  Duration(milliseconds: 10), () {
                  focusNode.requestFocus();
                });
              },
              child: Container(
                width: Get.width,
                padding:   EdgeInsetsDirectional.symmetric(
                    vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child:   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type Comment'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.emoji_emotions_outlined,
                        color: Colors.white, size: 20)
                  ],
                ),
              ),
            )),
              SizedBox(width: 8),
            // ============================= right section ==========================
            InkWell(
              onTap: () {
                showExitAndEndStreamPopUp(context: context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:   EdgeInsetsDirectional.symmetric(
                    vertical: 12, horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
                child:   Text('End'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showExitAndEndStreamPopUp({
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white70,
              child: SingleChildScrollView(
                physics:   ClampingScrollPhysics(),
                child: Container(
                  padding:   EdgeInsetsDirectional.symmetric(
                      vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Are you sure?'.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                        SizedBox(height: 12),
                      Text('You want to end the live stream'.tr,
                          style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              verticalPadding: 12,
                              fontSize: 14,
                              onPressed: () {
                                Get.back();
                                streamEndFunction();
                                exitAndGoToNewsFeed(context: context);
                              },
                              text: 'End Stream'.tr,
                            ),
                          ),
                            SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side:   BorderSide(
                                            color: Colors.redAccent,
                                            width: 1))),
                                child:   Text('No'.tr)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void exitAndGoToNewsFeed({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Disables the back button
        child: Container(
          color: Colors.black26,
          child: Container(
            padding:   EdgeInsetsDirectional.symmetric(
                vertical: 20, horizontal: 20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text('The Live Has Ended'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                  SizedBox(height: 12),
                PrimaryButton(
                  verticalPadding: 12,
                  onPressed: () {
                    Get.until((route) => Get.currentRoute == Routes.TAB);
                    //
                    // Get.offAndToNamed(Routes.TAB, arguments: {'initialTabIndex': 1});
                  },
                  text: 'Go to Newsfeed'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
