import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../controllers/help_support_controller.dart';

class CreateTicketView extends GetView<HelpSupportController> {
  const CreateTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Create Ticket'.tr,
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your full name'.tr,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  controller.complainerName.value = value.toString();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Topics'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryDropDownField(
                  hint: 'Topic',
                  list: controller.complainList.value,
                  onChanged: (changedValue) {
                    controller.complainType.value = changedValue.toString();
                  }),
              const SizedBox(
                height: 10,
              ),
              Text('Description'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Description'.tr,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  controller.complainDescription.value = value.toString();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Problem Screenshot (If Any)'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Visibility(
                  visible: controller.xfiles.value.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: const BoxDecoration(),
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.xfiles.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        XFile xFile = controller.xfiles.value[index];
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image(
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                image: FileImage(
                                  File(xFile.path),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: InkWell(
                                  onTap: () {
                                    controller.xfiles.value.removeAt(index);
                                    controller.xfiles.refresh();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.xfiles.value.isNotEmpty,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
              ),
              Obx(() => InkWell(
                  onTap: () {
                    controller.pickFiles();
                  },
                  child: Visibility(
                    visible: controller.xfiles.value.isEmpty,
                    child: const Image(
                      image: AssetImage(AppAssets.UPLOAD_HELP_TICKET_ICON),
                      fit: BoxFit.fitWidth,
                    ),
                  ),),),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: PrimaryButton(
                  onPressed: () async {
                    await controller.createTicket();
                    controller.getHelpSupportList();
                  },
                  text: 'Create'.tr,
                  horizontalPadding: 120,
                  verticalPadding: 15,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
