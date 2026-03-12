// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/dropdown.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/controllers/pages_controller.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/allpages_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

class DiscoverPageSearch extends StatelessWidget {
  const DiscoverPageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    PagesController controller = Get.find();
    controller.filteredPagesList.clear();
    controller.allpagesList.value.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Pages'.tr,
        ),
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: FOCUSED_BORDER,
                hintText: 'Search pages'.tr,
                hintStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.filteredPagesList.value =
                        controller.allpagesList.value;
                  },
                  icon: const Icon(Icons.search),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (String text) {
                if (controller.debounce?.isActive ?? false) {
                  controller.debounce?.cancel();
                }

                controller.debounce = Timer(const Duration(seconds: 2), () {
                  if (text.isNotEmpty) {
                    controller.getSearchPage(text);
                  } else {
                    controller.filteredPagesList.value =
                        List<AllPagesModel>.from(controller.allpagesList.value);
                  }
                });
              },
            ),
            const SizedBox(height: 40),
            Obx(() => Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.allpagesList.value.length,
                    itemBuilder: (context, index) {
                      AllPagesModel allPagesModel =
                          controller.allpagesList.value[index];

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.PAGE_PROFILE,
                                arguments: allPagesModel.pageUserName);
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
                                  (
                                      allPagesModel.coverPic ?? '').formatedProfileUrl,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                allPagesModel.pageName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                (allPagesModel.category as List<String>?)
                                        ?.join('') ??
                                    '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text('${allPagesModel.followerCount}-people follow'.tr,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    controller
                                        .followPage(allPagesModel.id ?? '');
                                  },
                                  child: Text('Follow'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
