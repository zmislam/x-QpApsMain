import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/image.dart';
import '../../group_admin/models/group_member_join_list_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

class CustomMemberRequestCard extends StatelessWidget {
  final GroupMemberRequestListModel model;
  final VoidCallback? onTapAccept;
  final VoidCallback? onTapDecline;

  CustomMemberRequestCard(
      {super.key, required this.model, this.onTapAccept, this.onTapDecline});

  RxString character = 'Spam'.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.OTHERS_PROFILE,
                  arguments: {
                    'username':model.user.username,
                    'isFromReels':'false'
                  });
            },
            child: Row(
              children: [
                RoundCornerNetworkImage(
                  imageUrl: (model.user.profilePic ?? '').formatedProfileUrl,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('${model.user.firstName} ${model.user.lastName}'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        //  Text('${model.createdAt}'.tr)
                        Text(
                          (model.createdAt
                              .toIso8601String()).toDetailFormatDateTime(), // Convert DateTime? to String?
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 50),
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 40,
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed:
                      onTapAccept, // Disable the button by setting onPressed to null
                  child: Text('Accept'.tr, // Button label
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed:
                      onTapDecline, // Disable the button by setting onPressed to null
                  child: Text('Decline'.tr, // Button label
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
