import 'package:flutter/material.dart';
import '../../extension/string/string_image_path.dart';
import '../../data/post_local_data.dart';
import '../../extension/date_time_extension.dart';
import '../../models/friend.dart';
import '../../models/post.dart';
import '../../modules/edit_post/controllers/edit_post_controller.dart';
import '../button.dart';
import '../dropdown.dart';
import '../image.dart';
import '../text_form_field.dart';
import 'package:get/get.dart';

class EditRelationBody extends StatelessWidget {
  const EditRelationBody(
      {super.key,
      required this.imageLink,
      required this.title,
      required this.onPressed,
      required this.controller,
      required this.postModel});
  final String imageLink;
  final String title;
  final VoidCallback onPressed;
  final EditPostController controller;
  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    controller.eventType.value = 'relationship';
    controller.eventSubType.value = postModel?.event_sub_type ?? '';
    controller.descriptionController.text = postModel?.description ?? '';
    controller.partnerName.value = '${postModel?.lifeEventId?.toUserId?.id}';
    controller.startDate.value =
        postModel?.lifeEventId?.date.toString().substring(0, 10) ?? '';
    controller.startDateController.text =
        postModel?.lifeEventId?.date.toString().substring(0, 10) ?? '';

    if (postModel?.post_privacy == 'only_me') {
      controller.dropdownValue.value = 'Only Me';
      controller.postPrivacy.value = 'only_me';
    } else if (postModel?.post_privacy == 'public') {
      controller.dropdownValue.value = 'Public';
      controller.postPrivacy.value = 'public';
    } else {
      controller.dropdownValue.value = 'Friends';
      controller.postPrivacy.value = 'friends';
    }

    FriendModel friendModel = FriendModel(
        id: '',
        friend: Friend(
          id: '',
          firstName: postModel?.lifeEventId?.toUserId?.firstName ?? '',
          lastName: postModel?.lifeEventId?.toUserId?.lastName ?? '',
          username: postModel?.lifeEventId?.toUserId?.username ?? '',
          email: postModel?.lifeEventId?.toUserId?.email ?? '',
          profilePic: postModel?.lifeEventId?.toUserId?.profilePic ?? '',
        ),
        fullName: postModel?.lifeEventId?.toUserId?.firstName ?? '',
        profilePic: postModel?.lifeEventId?.toUserId?.profilePic ?? '');

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageLink,
                width: 100,
                height: 100,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: TextFormField(
              controller: controller.descriptionController,
              textAlign: TextAlign.center,
              maxLines: 2,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Say something about this...'.tr,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                PrimaryEditDropDownSearch<FriendModel>(
                  padding: const EdgeInsets.all(17),
                  hintText: 'Partner Name'.tr,
                  items: controller.friendController.friendList.value,
                  itemBuilder: (context, item, isSelected) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                          child: NetworkCircleAvatar(
                            radius: 19,
                            imageUrl: (item.friend?.profilePic ?? '')
                                .formatedProfileUrl,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(item.friend?.firstName ?? '')
                      ],
                    );
                  },
                  onChanged: (friendModel) {
                    controller.partnerName.value =
                        friendModel?.friend?.id ?? '';
                  },
                  selectedItem: friendModel,
                ),
                const SizedBox(
                  height: 10,
                ),
                PrimaryDropDownField(
                    hint: 'Privacy',
                    value: controller.dropdownValue.value,
                    list: privacyList,
                    onChanged: (changedValue) {
                      if (changedValue == 'Only Me') {
                        controller.postPrivacy.value = 'only_me';
                      } else {
                        controller.postPrivacy.value =
                            changedValue!.toLowerCase();
                      }
                    }),
                const SizedBox(height: 10),
                ClickableTextFormField(
                  label: 'Start Date'.tr,
                  suffixIcon: Icons.calendar_month_outlined,
                  controller: controller.startDateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        controller.startDateController.text =
                            '${value.year}-${value.month}-${value.day}';
                        controller.startDate.value =
                            controller.startDateController.text;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          PrimaryButton(
            onPressed: onPressed,
            text: 'update'.tr,
            horizontalPadding: 150,
            verticalPadding: 12,
          )
        ],
      ),
    );
  }

  String getDynamicFormatedTime(String time) {
    // print("time of date ........."+time);

    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    // DateTime currentDatetime = DateTime.now();
    // Calculate the difference in milliseconds
    // int millisecondsDifference = currentDatetime.millisecondsSinceEpoch -
    //     postDateTime.millisecondsSinceEpoch;
    // // Convert to minutes (ignoring milliseconds)
    // int minutesDifference =
    // (millisecondsDifference / Duration.millisecondsPerMinute).truncate();
    //
    // if (DateUtils.isSameDay(postDateTime, currentDatetime)) {
    //   return 'Today at ${postTimeFormate.format(postDateTime)}';
    // } else {
    //
    // }

    return productDateTimeFormat.format(postDateTime);
  }
}
