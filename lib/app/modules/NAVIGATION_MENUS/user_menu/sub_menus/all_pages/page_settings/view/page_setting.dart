import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin_page/controller/admin_page_controller.dart';
import 'page_admin.dart';
import 'page_basic_information.dart';
import 'page_privacy.dart';

class PageSetting extends StatelessWidget {
  const PageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();
    // String pageProfileModel = Get.arguments;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(' Page '.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const PageBasicInformatio());
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Page Basic information'.tr)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: adminPageController.pageProfileModel.value?.role !=
                  'moderator',
              child: InkWell(
                onTap: () {
                  Get.to(() => const PagePrivacy());
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.privacy_tip_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Page Privacy'.tr)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: const Row(
            //       children: [
            //         SizedBox(
            //           width: 15,
            //         ),
            //         Icon(Icons.block_outlined),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Text('Blocking'.tr)
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            Visibility(
              visible: adminPageController.pageProfileModel.value?.role !=
                  'moderator',
              child: InkWell(
                onTap: () {
                  Get.to(() => const PageAdmin());
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child:  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.add_moderator_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Admin & Moderator'.tr)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: adminPageController.pageProfileModel.value?.role !=
                  'moderator',
              child: InkWell(
                onTap: () {
                  adminPageController.deletePage(adminPageController
                          .pageProfileModel.value?.pageDetails?.id ??
                      '');
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Delete Page'.tr,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
