import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/date_time_extension.dart';
import '../../../../extension/string/string_image_path.dart';
import '../controllers/settings_privacy_controller.dart';
import '../models/block_list_model.dart';
import '../../../../config/constants/color.dart';

class BlockListCard extends StatelessWidget {
  BlockListCard({
    super.key,
    required this.model,
    required this.controller,
  });

  //  friendController = Get.put(FriendController());

  RxString character = 'Spam'.obs;

  final Blocklist model;
  final SettingsPrivacyController controller;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          radius: 36,
          backgroundImage: const AssetImage('AppAssets.DEFAULT_PROFILE_IMAGE'),
          foregroundImage: NetworkImage(
              (model.blockedTo?.profilePic ?? '').formatedProfileUrl)),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.blockedTo?.firstName ?? ''} ${model.blockedTo?.lastName ?? ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  (model.createdAt ?? '').toWordlyTimeText(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  controller.unBlockFriends(userId: model.blockedTo?.id ?? '');
                },
                child: Text('Unblock'.tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
