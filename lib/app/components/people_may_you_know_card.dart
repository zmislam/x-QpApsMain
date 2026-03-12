import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/string/string_image_path.dart';
import '../config/constants/app_assets.dart';

import '../modules/NAVIGATION_MENUS/friend/model/people_may_you_khnow.dart';
import '../routes/app_pages.dart';
import '../config/constants/color.dart';

class PeopleMayYouKnowCard extends StatelessWidget {
  const PeopleMayYouKnowCard({
    super.key,
    required this.peopleMayYouKnowModel,
    required this.onPressedAddFriend,
    required this.onPressedRemove,
  });
  final PeopleMayYouKnowModel peopleMayYouKnowModel;
  final VoidCallback onPressedAddFriend;
  final VoidCallback onPressedRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // =========================== image section =========================
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
                image: NetworkImage((
                    peopleMayYouKnowModel.profile_pic ?? '').formatedProfileUrl)),
          ),
          const SizedBox(
            width: 20,
          ),
          // =========================== friend info section ===================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                      'username': peopleMayYouKnowModel.username,
                      'isFromReels': 'false'
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        '${peopleMayYouKnowModel.first_name ?? ''} ${peopleMayYouKnowModel.last_name ?? ''}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      if (peopleMayYouKnowModel.isProfileVerified == true)
                       Icon(
                          Icons.verified,
                          color: PRIMARY_COLOR,
                          size: 16,
                        ),
                    ],
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
                    // ================= add friend button =====================
                    Expanded(
                      child: Container(
                        height: 35,
                        width: 120,
                        decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: onPressedAddFriend,
                          child: Text('Add Friend'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // ================= remove button =========================
                    Expanded(
                      child: Container(
                        height: 35,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: onPressedRemove,
                          child: Text('Remove'.tr,
                            style: TextStyle(color: PRIMARY_COLOR),
                          ),
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
