import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../../pages/controllers/pages_controller.dart';
import '../../pages/model/invitation_model.dart';
import '../../pages/model/manage_page_model.dart';

class ManagePagesView extends StatefulWidget {
  const ManagePagesView({super.key});

  @override
  State<ManagePagesView> createState() => _MyPagesViewState();
}

class _MyPagesViewState extends State<ManagePagesView> {
  @override
  Widget build(BuildContext context) {
    PagesController controller = Get.find();
    double screenWidth = MediaQuery.of(context).size.width;

    controller.getManagePages();

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                // backgroundColor: Colors.white,
                title: Text('Manage Pages'.tr,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                leading: const BackButton(
                  color: Colors.black,
                ),
              ),
              const Divider(),
              Obx(() => GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.managepagesList.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      ManagePageModel managePageModel =
                          controller.managepagesList.value[index];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.ADMIN_PAGE,
                              arguments: managePageModel.pageUserName,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                errorBuilder: (context, error, stackTrace) {
                                  return const Image(
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      AppAssets.DEFAULT_IMAGE,
                                    ),
                                  );
                                },
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    ('${controller.managepagesList.value[index].coverPic}')
                                        .formatedProfileUrl),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('${managePageModel.pageName}'.tr,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text((managePageModel.category as List<String>?)
                                      ?.join('') ??
                                  ''),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('${managePageModel.followerCount ?? 0} - followers'.tr),
                              const SizedBox(
                                height: 5,
                              ),
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: screenWidth * 0.3,
                                        decoration: BoxDecoration(
                                            color: PRIMARY_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: TextButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                Routes.ADMIN_PAGE,
                                                arguments: managePageModel
                                                    .pageUserName,
                                              );
                                            },
                                            child: Text('View Page'.tr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ),
                                      Container(
                                        height: 35,
                                        width: screenWidth * 0.1,
                                        decoration: BoxDecoration(
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: PopupMenuButton(
                                            offset: const Offset(10, 50),
                                            iconColor: Colors.white,
                                            icon: const Center(
                                                child: Image(
                                                    width: 20,
                                                    image: AssetImage(AppAssets
                                                        .MORE_VERT_ICON))),
                                            iconSize: 25,
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      controller
                                                          .getPagesInvites(
                                                              managePageModel
                                                                      .id ??
                                                                  '');
                                                      Get.bottomSheet(Obx(
                                                        () => Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text('Invite Your friends to this Page'.tr,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.close))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text('Select All'.tr,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Obx(() =>
                                                                        Checkbox(
                                                                          activeColor:
                                                                              PRIMARY_COLOR,
                                                                          value:
                                                                              controller.selectedPageInvitationList.value.length == controller.pageInvitationList.value.length,
                                                                          onChanged:
                                                                              (bool? value) {
                                                                            if (value !=
                                                                                null) {
                                                                              if (value) {
                                                                                controller.selectedPageInvitationList.value = controller.pageInvitationList.value.toList();
                                                                              } else {
                                                                                controller.selectedPageInvitationList.value.clear();
                                                                              }
                                                                              controller.selectedPageInvitationList.refresh();
                                                                            }
                                                                          },
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: controller
                                                                            .pageInvitationList
                                                                            .value
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          PageInvitationModel
                                                                              pageInvitationModel =
                                                                              controller.pageInvitationList.value[index];
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              SizedBox(
                                                                                height: 60,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      radius: 20,
                                                                                      child: ClipOval(
                                                                                        child: Image(
                                                                                          image: NetworkImage((pageInvitationModel.profilePic ?? '').formatedProfileUrl),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 10),
                                                                                    Text(
                                                                                      pageInvitationModel.fullName ?? '',
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Obx(
                                                                                () => Checkbox(
                                                                                  activeColor: PRIMARY_COLOR,
                                                                                  value: controller.selectedPageInvitationList.value.contains(pageInvitationModel),
                                                                                  onChanged: (bool? changed) {
                                                                                    if (changed != null) {
                                                                                      if (changed) {
                                                                                        controller.selectedPageInvitationList.value.add(pageInvitationModel);
                                                                                        // controller.selectedPageInvitationList.refresh();
                                                                                      } else {
                                                                                        controller.selectedPageInvitationList.value.clear();
                                                                                      }
                                                                                      controller.selectedPageInvitationList.refresh();
                                                                                    }
                                                                                    // controller.updateCheckBox.value == changed!;
                                                                                    // controller.selectedPageInvitationList.value.add(pageInvitationModel);
                                                                                    // controller.selectedPageInvitationList.refresh();
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          );
                                                                        }),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        PRIMARY_COLOR,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    controller.sendFriendInvitation(
                                                                        managePageModel.id ??
                                                                            '');
                                                                  },
                                                                  child:
                                                                      Text('Send'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text('Invite Connections'.tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
