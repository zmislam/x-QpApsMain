import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/button.dart';
import '../../../../models/gender.dart';
import '../controllers/signup_controller.dart';

class GenderView extends GetView<SignupController> {
    GenderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.getGenders();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child:   Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
              Center(
              child: Text('Gender'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding:   EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                  Divider(height: 1),
                  SizedBox(height: 40),
                  Text(
                  "What's your gender?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  SizedBox(height: 10),
                Text('You can change who sees your gender on your profile later.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                  SizedBox(height: 40),
                Column(
                  children: controller.genderList.value
                      .map((element) => Column(
                            children: [
                              RadioListTile(
                                title:Text(element.gender_name??'', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
                                value:element, 
                                groupValue: controller.selectedGender.value, 
                            onChanged: (GenderModel? value) {
                                      controller.selectedGender.value = value;
                                      controller.selectedGender.refresh();
                                    },),
                              
                                Divider()
                            ],
                          ))
                      .toList(),
                ),
                  SizedBox(height: 40),
                Padding(
                  padding:   EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            onPressed: controller.onClickNextFromGender,
                            text: 'Next'.tr),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
