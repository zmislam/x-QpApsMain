import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import 'group_search.dart';
import 'page_search.dart';
import 'photo_search.dart';
import 'reels_search.dart';
import 'video_search.dart';
import 'people_search.dart';
import 'post_search.dart';

import '../controllers/global_search_controller.dart';
import 'all_search.dart';

class GlobalSearchView extends GetView<GlobalSearchController> {
    GlobalSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      controller.tabIndex.value = 3;
    }
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                  SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.searchController.clear();
                        Get.back();
                      },
                      icon:   Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.black87,
                      ),
                    ),
                      SizedBox(width: 8),
                    Expanded(
                        child: Container(
                      margin:   EdgeInsets.only(right: 16),
                      height: 47.86,
                      width: Get.width - 45,
                      padding:   EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(
                              alpha: 0.1), //Color.fromARGB(135, 238, 238, 238),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey.withValues(alpha: 0.9),
                          ),
                            SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding:   EdgeInsets.only(bottom: 5.0),
                              child: SizedBox(
                                width: Get.width - 90,
                                child: TextFormField(
                                  textInputAction: TextInputAction.search,
                                  controller: controller.searchController,
                                  decoration:   InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      hintText: 'Search'.tr,
                                      hintStyle: TextStyle(color: Colors.grey)),
                                  onChanged: (value) {
                                    controller.getSearchPeople();
                                    controller.getPosts();
                                    controller.getPhotos();
                                    controller.getVideos();
                                    controller.getGroups();
                                    controller.getPages();
                                    controller.getReelsSearch();
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                  SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                  SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: Get.width,
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 0;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 0
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('All'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 1;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 1
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Post'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 2;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 2
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('People'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 3;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 3
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Reels'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 4;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 4
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Videos'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 5;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 5
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Group'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 6;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 6
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Page'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        controller.tabIndex.value = 7;
                      },
                      child: Obx(
                        () => Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: controller.tabIndex.value == 7
                                ? Colors.grey.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                          child:   Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Photos'.tr,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
            SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          Obx(() {
            if (controller.tabIndex.value == 0) {
              return   AllSearch();
            } else if (controller.tabIndex.value == 1) {
              return SliverList(
                  delegate: SliverChildListDelegate([  PostSearch()]));
            } else if (controller.tabIndex.value == 2) {
              return SliverList(
                  delegate: SliverChildListDelegate([  PeopleSearch()]));
            } else if (controller.tabIndex.value == 3) {
              return SliverList(
                  delegate: SliverChildListDelegate([  ReelsSearch()]));
            } else if (controller.tabIndex.value == 4) {
              return SliverList(
                  delegate: SliverChildListDelegate([  VideoSearch()]));
            } else if (controller.tabIndex.value == 5) {
              return SliverList(
                  delegate: SliverChildListDelegate([  GroupSearch()]));
            } else if (controller.tabIndex.value == 6) {
              return SliverList(
                  delegate: SliverChildListDelegate([  PageSearch()]));
            } else if (controller.tabIndex.value == 7) {
              return SliverList(
                  delegate: SliverChildListDelegate([  PhotoSearch()]));
            } else {
              return   SliverToBoxAdapter();
            }
          })
        ],
      ),
    ));
  }
}
