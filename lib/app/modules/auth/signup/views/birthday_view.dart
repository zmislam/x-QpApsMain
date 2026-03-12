import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class BirthdayView extends GetView<SignupController> {
    BirthdayView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.white,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child:   Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
              Text('Birthday'.tr, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Container(
        height: Get.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
                Divider(height: 1),
                SizedBox(height: 40),
                Text('What’s your birthday?'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                SizedBox(height: 10),
              Text('We’ll help you\ncreate a new account in a few easy steps.'.tr,
                style: TextStyle(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
                SizedBox(height: 80),
              Padding(
                padding:   EdgeInsets.all(40),
                child: DatePickerWidget(
                  looping: true, // default is not looping
                  firstDate: DateTime(1950, 01, 01),
                  lastDate: DateTime.now().subtract(  Duration(days: 4750)),
                  initialDate: DateTime(2000, 01, 01),
                  dateFormat: 'dd-MMM-yyyy',
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, context) {
                    controller.onSelectDate(newDate);
                  },
                  pickerTheme:   DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.black,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
                SizedBox(height: 40),
              Obx(
                () => Text('${controller.year.value.toStringAsFixed(0)} years old'.tr,
                  style:   TextStyle(color: Colors.black),
                ),
              ),
                SizedBox(height: 40),
              Padding(
                padding:   EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                          onPressed: () {
                            Get.toNamed(Routes.GENDER);
                          },
                          text: 'Next'.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
