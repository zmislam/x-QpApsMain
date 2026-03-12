import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../admin_page/controller/admin_page_controller.dart';
import 'page_add_admin_moderator.dart';
import '../../../../../../../config/constants/color.dart';
import '../../pages/model/admin_moderator_model.dart';
import '../../pages/model/admin_page_make_admin_model.dart';

class PageAdmin extends StatelessWidget {
  const PageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    AdminPageController adminPageController = Get.find();

    double screenWidth = MediaQuery.of(context).size.width;

    adminPageController.getPageAdmin(
        adminPageController.pageProfileModel.value?.pageDetails?.id ?? '');

    return RefreshIndicator(
      onRefresh: () async {
        adminPageController.getPageAdmin(
            adminPageController.pageProfileModel.value?.pageDetails?.id ?? '');
      },
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white,
            leading: const BackButton(
              color: Colors.black,
            ),
            title: Text('Page Settings'.tr,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          // backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Page Admin & moderator'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const PageAddAdminModerator());
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: PRIMARY_COLOR,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              size: 15,
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Add'.tr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Expanded(
                    child: ListView.builder(
                        itemCount: adminPageController
                            .pageAdminModeratorList.value.length,
                        itemBuilder: (context, index) {
                          AdminModeratorModel adminModeratorModel =
                              adminPageController
                                  .pageAdminModeratorList.value[index];
                          return SizedBox(
                            height: 100,
                            width: double.infinity,
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.grey.shade200),
                            //     borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      (adminModeratorModel.userId?.profilePic ??
                                              '')
                                          .formatedProfileUrl,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${adminModeratorModel.userId?.firstName ?? ''} ${adminModeratorModel.userId?.lastName ?? ''}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        adminModeratorModel.userRole ?? '',
                                        style: TextStyle(
                                            fontSize: 16, color: GREY_COLOR),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  IconButton(
                                      onPressed: () {
                                        Get.bottomSheet(Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 100,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  adminPageController
                                                      .getPageAdminList(); // Fetch the list of page admins

                                                  Get.bottomSheet(
                                                    Container(
                                                      height: 500,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('People'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText: 'Search People'.tr,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .search),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                adminPageController
                                                                    .searchFriends(
                                                                        value);
                                                              },
                                                            ),

                                                            const SizedBox(
                                                                height: 10),
                                                            Text('All Friends'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),

                                                            // Display Selected Friend(s)
                                                            Obx(
                                                              () => Visibility(
                                                                visible: adminPageController
                                                                    .selectedPageAdminList
                                                                    .isNotEmpty,
                                                                child: SizedBox(
                                                                  height: 40,
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemCount: adminPageController
                                                                        .selectedPageAdminList
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      PageMakeAdminModel
                                                                          selectedFriend =
                                                                          adminPageController
                                                                              .selectedPageAdminList[index];

                                                                      return Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text(selectedFriend.friend?.firstName ?? ''),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  adminPageController.selectedPageAdminList.removeAt(index);
                                                                                  adminPageController.selectedPageAdminList.refresh();
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.black,
                                                                                  size: 20,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // Display the Friend List
                                                            Expanded(
                                                              child: Obx(
                                                                () => ListView
                                                                    .builder(
                                                                  itemCount:
                                                                      adminPageController
                                                                          .filteredFriendList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    PageMakeAdminModel
                                                                        pageMakeAdminModel =
                                                                        adminPageController
                                                                            .filteredFriendList[index];

                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (!adminPageController
                                                                            .selectedPageAdminList
                                                                            .contains(pageMakeAdminModel)) {
                                                                          adminPageController
                                                                              .selectedPageAdminList
                                                                              .add(pageMakeAdminModel);
                                                                          adminPageController
                                                                              .selectedPageAdminList
                                                                              .refresh();
                                                                        }
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            60,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundImage: NetworkImage(
                                                                                (pageMakeAdminModel.profilePic ?? '').formatedProfileUrl,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Text(
                                                                              pageMakeAdminModel.fullName ?? '',
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                                height: 10),

                                                            // Button to Confirm Transfer
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Container(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      PRIMARY_COLOR,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Obx(
                                                                  () =>
                                                                      TextButton(
                                                                    onPressed: adminPageController
                                                                            .selectedPageAdminList
                                                                            .isNotEmpty
                                                                        ? () {
                                                                            final transferUserId =
                                                                                adminPageController.selectedPageAdminList.first.friend?.id ?? '';
                                                                            adminPageController.transferPageAdmin(adminPageController.pageUserName ?? '',
                                                                                transferUserId);
                                                                          }
                                                                        : null,
                                                                    child:
                                                                        Text('Add'.tr,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                          height: 18,
                                                          image: AssetImage(
                                                              AppAssets
                                                                  .TRANSFER_ICON)),
                                                      SizedBox(width: 10),
                                                      Text('Transfer Ownership'.tr,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();

                                                  Get.dialog(
                                                    AlertDialog(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      content: SizedBox(
                                                        height: 200,
                                                        width: Get.width,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Header section
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .remove_circle_rounded,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text('Remove Page Admin!'.tr,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),

                                                            // Confirmation text
                                                            Text(
                                                              'Are you sure you want to remove ${adminModeratorModel.userId?.firstName ?? ''} from ${adminPageController.pageProfileModel.value?.pageDetails?.pageName ?? ''}? They will lose all admin rights. This action cannot be undone.',
                                                              style:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            // Action buttons
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        screenWidth *
                                                                            0.3,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            12),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color:
                                                                              GREY_COLOR),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                    Center(
                                                                      child: Text('Cancel'.tr,
                                                                          style:
                                                                              TextStyle(color: Colors.black)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                InkWell(
                                                                  onTap: () {
                                                                    adminPageController.removePageAdmin(
                                                                        adminModeratorModel.id ??
                                                                            '');
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        screenWidth *
                                                                            0.3,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            12),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                    Center(
                                                                      child:
                                                                          Text('Remove'.tr,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white), // Text color
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      const Image(
                                                          height: 20,
                                                          image: AssetImage(
                                                              AppAssets
                                                                  .DELETE_ICON)),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(
                                                        'Remove ${adminModeratorModel.userRole ?? ''}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                      },
                                      icon: const Icon(Icons.more_vert))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
