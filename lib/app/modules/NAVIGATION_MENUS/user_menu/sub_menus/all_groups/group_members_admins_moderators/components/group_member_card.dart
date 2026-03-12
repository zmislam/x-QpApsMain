import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../controllers/group_members_admins_moderators_controller.dart';
import '../models/all_group_members_admins_moderators_model.dart';
import '../../../../../../../config/constants/color.dart';

class GroupMemberCard extends StatelessWidget {
  final GroupMemberList model;
  final VoidCallback? onTapUnfriend;
  final VoidCallback? onPressBlockFriend;
  final GroupMembersAdminsModeratorsController controller;

  GroupMemberCard(
      {super.key,
      required this.model,
      this.onTapUnfriend,
      this.onPressBlockFriend,
      required this.controller});

  RxString character = 'Spam'.obs;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          RoundCornerNetworkImage(
            imageUrl: (
                model.groupMemberUserId?.profilePic ?? '').formatedProfileUrl,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${model.groupMemberUserId?.firstName ?? ''} ${model.groupMemberUserId?.lastName ?? ''}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    model.role?.capitalizeFirst ?? 'Member',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ProfileNavigator.navigateToProfile(
                  username: model.groupMemberUserId?.username ?? '',
                  isFromReels: 'false');
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle),
              child: Text('View Profile'.tr,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
