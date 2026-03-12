import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../config/constants/color.dart';
import '../controllers/settings_privacy_controller.dart';

class PersonalDetailsFormView extends GetView<SettingsPrivacyController> {
  const PersonalDetailsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          title: Text('Personal Details'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: Obx(
        () => controller.isLoadingSettings.value == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: PRIMARY_COLOR,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title or Header
                      Text('Personal Details'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.transparent), color: Theme.of(context).cardTheme.color),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('First name'.tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // First Name TextField
                            TextFormField(
                              controller: controller.firstNameController.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // Last Name TextField
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Last name'.tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              controller: controller.lastNameController.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Phone Number'.tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Phone  TextField
                            TextFormField(
                              controller: controller.phoneController.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Email address'.tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Email Address TextField
                            TextFormField(
                              controller: controller.emailAddressController.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Date of Birth'.tr,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
// date of birth
                            TextFormField(
                              controller: controller.dobController.value,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true, // To make it uneditable, user can only select from the calendar
                              onTap: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: controller.dobString != null ? DateTime.tryParse(controller.dobString!) : DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (selectedDate != null) {
                                  String formattedDate = DateFormat('MMM dd, yyyy').format(selectedDate);
                                  controller.dobController.value.text = formattedDate;
                                }
                              },
                              keyboardType: TextInputType.none,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // Update and Add Contact  Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(border: Border.all(color: PRIMARY_COLOR, width: 2), borderRadius: BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () async {
                                        //============================ Add Contact BottomSheet ====================================//
                                        await Get.bottomSheet(
                                            backgroundColor: Theme.of(context).cardTheme.color,
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Title
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 20.0),
                                                    child: Text('Add Contacts'.tr,
                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text('Phone Number'.tr,
                                                    style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Phone Input
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                                    child: InternationalPhoneNumberInput(
                                                      // autoValidateMode:
                                                      //     AutovalidateMode
                                                      //         .onUserInteraction,
                                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                      textFieldController: controller.addPhoneController.value,
                                                      initialValue: controller.number,
                                                      onInputChanged: (phoneNumber) {
                                                        controller.fullPhoneNumber.value = phoneNumber.phoneNumber ?? '';
                                                        debugPrint(' FULLL NUMBER::: ${controller.fullPhoneNumber.value}');
                                                        debugPrint(phoneNumber.phoneNumber);
                                                      },
                                                      selectorConfig: const SelectorConfig(
                                                        selectorType: PhoneInputSelectorType.DIALOG,
                                                        useBottomSheetSafeArea: true,
                                                      ),
                                                      inputDecoration: InputDecoration(
                                                        // labelText: 'Phone'.tr,
                                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                                        hintText: 'Enter phone number'.tr,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text('Email Address'.tr,
                                                    style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Email Input
                                                  TextField(
                                                    controller: controller.addEmailAddressController.value,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email Address'.tr,
                                                      border: OutlineInputBorder(),
                                                      hintText: 'Enter email address'.tr,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),

                                                  // Buttons Row (Submit & Reset)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // Reset Button
                                                      Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          decoration: BoxDecoration(border: Border.all(color: PRIMARY_COLOR, width: 2), borderRadius: BorderRadius.circular(10)),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              controller.resetContactData();
                                                            },
                                                            child: Text('Reset'.tr,
                                                              style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 15),
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
                                                          decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(10)),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              controller.onTapAddContactPost();
                                                            },
                                                            child: Text('Submit'.tr,
                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                      child: Text('Add Contact'.tr,
                                        style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () {
                                        controller.updatePersonalInfo();
                                      },
                                      child: Text('Update'.tr,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
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
