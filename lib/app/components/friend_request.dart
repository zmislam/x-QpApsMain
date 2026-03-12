// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/firend_request.dart';
import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

import '../config/constants/app_assets.dart';
import '../routes/app_pages.dart';
import '../config/constants/color.dart';

class FriendRequestCard extends StatelessWidget {
  const FriendRequestCard({
    super.key,
    required this.friendRequestModel,
    required this.onPressedAccept,
    required this.onPressedReject,
  });
  final FriendRequestModel friendRequestModel;
  final VoidCallback onPressedAccept;
  final VoidCallback onPressedReject;

  @override
  Widget build(BuildContext context) {
    UserIdModel userIdModel = friendRequestModel.user_id!;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Image(
                    height: 80,
                    width: 80,
                    image: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                  );
                },
                fit: BoxFit.cover,
                image: NetworkImage(
                    (userIdModel.profile_pic ?? '').formatedProfileUrl)),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                      'username': friendRequestModel.user_id?.username,
                      'isFromReels': 'false'
                    });
                  },
                  child: Text(
                    '${userIdModel.first_name ?? ''} ${userIdModel.last_name ?? ''}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('1 mutual friend'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: onPressedAccept,
                        child: Text('Accept'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: onPressedReject,
                        child: Text('Decline'.tr,
                          style: TextStyle(color: PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
