import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/text_form_field.dart';
import '../../../../../../../config/constants/color.dart';
import '../../admin_page/controller/admin_page_controller.dart';

class PageBasicInformatio extends StatelessWidget {
  const PageBasicInformatio({super.key});

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Page Setting'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: adminPageController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text('Page Basic information'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(' Page Name'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.pageNameController
                    ..text = adminPageController
                            .pageProfileModel.value?.pageDetails?.pageName ??
                        'Page Name',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a page name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Page Bio'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.bioController
                    ..text = adminPageController
                            .pageProfileModel.value?.pageDetails?.bio ??
                        '',
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                    hintText: ' Page Bio '.tr,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Page Description'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.descriptionController
                    ..text = adminPageController
                            .pageProfileModel.value?.pageDetails?.description ??
                        '',
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Page Description'.tr,
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Location'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.locationController
                    ..text = (adminPageController.pageProfileModel.value
                            ?.pageDetails?.location as List)
                        .join(', '),
                  decoration: InputDecoration(
                    hintText: 'Location'.tr,
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Phone Number'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.phoneNumberController
                    ..text = adminPageController
                            .pageProfileModel.value?.pageDetails?.phoneNumber ??
                        '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final RegExp phoneRegex = RegExp(
                      r'^\+?(\d{1,3})?[-.\s]?(\(?\d{2,3}?\)?)?[-.\s]?(\d{3})[-.\s]?(\d{4})$',
                    );

                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Whatsapp Number'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.whatsAppNumberController
                    ..text = adminPageController.pageProfileModel.value
                            ?.pageDetails?.whatsappNumber ??
                        '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final RegExp phoneRegex = RegExp(
                      r'^\+?(\d{1,3})?[-.\s]?(\(?\d{2,3}?\)?)?[-.\s]?(\d{3})[-.\s]?(\d{4})$',
                    );

                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Email'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.emailController
                    ..text = adminPageController
                            .pageProfileModel.value?.pageDetails?.email ??
                        '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final RegExp phoneRegex = RegExp(
                      // r'^\+?(\d{1,3})?[-.\s]?(\(?\d{2,3}?\)?)?[-.\s]?(\d{3})[-.\s]?(\d{4})$',
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );

                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Website'.tr,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: adminPageController.websiteController,
                  decoration: InputDecoration(
                    hintText: 'Website'.tr,
                    border: OutlineInputBorder(),
                    focusedBorder: FOCUSED_BORDER,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final RegExp phoneRegex = RegExp(
                      r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9.-]+)(\.[a-zA-Z]{2,})(\/[^\s]*)?$',
                    );

                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: adminPageController.isSaveButtonEnabled.value ==
                            false
                        ? () {
                            if (adminPageController.formKey.currentState
                                    ?.validate() ??
                                false) {
                              adminPageController.editPage(adminPageController
                                      .pageProfileModel
                                      .value
                                      ?.pageDetails
                                      ?.id ??
                                  '');
                            }
                            // adminPageController.editPage(adminPageController
                            //         .pageProfileModel.value?.pageDetails?.id ??
                            //     '');
                          }
                        : null,
                    child: Text('Save Changes'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
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
