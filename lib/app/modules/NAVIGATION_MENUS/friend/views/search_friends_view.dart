import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/dropdown.dart';
import '../../../../config/constants/app_assets.dart';
import '../model/search_people_model.dart';
import '../controllers/friend_controller.dart';
import 'search_people_card.dart';

class SearchFriendsView extends GetView<FriendController> {
  const SearchFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.peopleList.value.clear();
    controller.friendList.value.clear();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Friends'.tr,
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: FOCUSED_BORDER,
                hintText: 'Search people'.tr,
                hintStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.peopleList.value.toString();
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
                    controller.getSearchPeople(text);
                  }
                });
              },
            ),
            const SizedBox(height: 40),
            Obx(() => controller.peopleList.value.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          AppAssets.SEARCH_FRIENDS_ICON,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Search People'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text('Search for a friend or someone you may know to connect with them on Quantum Possibilities'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.peopleList.value.length,
                      itemBuilder: (context, index) {
                        SearchPeopleModel searchPeopleModel =
                            controller.peopleList.value[index];
                        return SearchPeopleCard(
                          searchPeopleModel: searchPeopleModel,
                          onPressedAddFriend: () {
                            controller.sendFriendRequest(
                                index: index,
                                userId: searchPeopleModel.id ?? '');
                          },
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
