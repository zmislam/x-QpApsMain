import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/dropdown.dart';
import '../controller/admin_page_controller.dart';
import '../../pages/model/invitation_model.dart';
import '../../../../../../../config/constants/color.dart';

class AdminPageInvites extends StatefulWidget {
  const AdminPageInvites({super.key});

  @override
  State<AdminPageInvites> createState() => _InvitesState();
}

class _InvitesState extends State<AdminPageInvites> {
  @override
  Widget build(BuildContext context) {
    AdminPageController controller = Get.find();
    controller.getPagesInvites(
        controller.pageProfileModel.value?.pageDetails?.id ?? '', '');
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Invite Friends'.tr,
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Search Bar with Filtering
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: FOCUSED_BORDER,
                hintText: 'Search Friends'.tr,
                hintStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                suffixIcon: Obx(() => controller.keyword.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.keyword.value = '';
                          controller.getPagesInvites(
                              controller.pageProfileModel.value?.pageDetails
                                      ?.id ??
                                  '',
                              '');
                        },
                      )
                    : const Icon(Icons.search)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (String text) {
                if (controller.debounce?.isActive ?? false) {
                  controller.debounce?.cancel();
                }

                controller.debounce =
                    Timer(const Duration(milliseconds: 500), () {
                  controller.keyword.value = text;
                  controller.getPagesInvites(
                      controller.pageProfileModel.value?.pageDetails?.id ?? '',
                      text);
                });
              },
            ),

            const SizedBox(height: 10),

            // 🔹 Select All Checkbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select All'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Obx(() => Checkbox(
                        activeColor: PRIMARY_COLOR,
                        value: controller
                                .selectedPageInvitationList.value.length ==
                            controller.pageInvitationList.value.length,
                        onChanged: (bool? value) {
                          if (value != null) {
                            if (value) {
                              controller.selectedPageInvitationList.value =
                                  controller.pageInvitationList.value.toList();
                            } else {
                              controller.selectedPageInvitationList.value
                                  .clear();
                            }
                            controller.selectedPageInvitationList.refresh();
                          }
                        },
                      )),
                ],
              ),
            ),

            // 🔹 Filtered Friends List
            Obx(() {
              List<PageInvitationModel> filteredList = controller
                  .pageInvitationList.value
                  .where((friend) =>
                      friend.fullName
                          ?.toLowerCase()
                          .contains(controller.keyword.value.toLowerCase()) ??
                      false)
                  .toList();

              if (filteredList.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      PageInvitationModel pageInvitationModel =
                          filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    child: ClipOval(
                                      child: Image(
                                        image: NetworkImage(
                                            (pageInvitationModel.profilePic ??
                                                    '')
                                                .formatedProfileUrl),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(pageInvitationModel.fullName ?? ''),
                                ],
                              ),
                            ),
                            Obx(
                              () => Checkbox(
                                activeColor: PRIMARY_COLOR,
                                value: controller.selectedPageInvitationIds
                                    .contains(pageInvitationModel.id),
                                onChanged: (bool? changed) {
                                  if (changed != null) {
                                    if (changed) {
                                      controller.selectedPageInvitationIds
                                          .add(pageInvitationModel.id!);
                                    } else {
                                      controller.selectedPageInvitationIds
                                          .remove(pageInvitationModel.id);
                                    }
                                    controller.selectedPageInvitationIds
                                        .refresh();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('No matching friends found'.tr,
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),

            const SizedBox(height: 20),

            // 🔹 Send Invitation Button
            Obx(
              () => Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: controller
                                .selectedPageInvitationList.value.isNotEmpty ||
                            controller.selectedPageInvitationIds.isNotEmpty
                        ? PRIMARY_COLOR
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed:
                      controller.selectedPageInvitationList.value.isNotEmpty
                          ? () {
                              controller.sendFriendInvitation(controller
                                      .pageProfileModel
                                      .value
                                      ?.pageDetails
                                      ?.id ??
                                  '');
                            }
                          : null,
                  child: Text('Send'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
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
