import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../friend/model/people_may_you_khnow.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/color.dart';

class CustomPeopleMayYouKnowCard extends StatelessWidget {
  const CustomPeopleMayYouKnowCard(
      {super.key,
      required this.peopleMayYouKnowModel,
      required this.onPressedAddFriend,
      required this.onPressedRemove});
  final PeopleMayYouKnowModel peopleMayYouKnowModel;
  final VoidCallback onPressedAddFriend;
  final VoidCallback onPressedRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                'username': peopleMayYouKnowModel.username,
                'isFromReels': 'false'
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                  height: 230,
                  width: 230,
                  errorBuilder: (context, error, stackTrace) {
                    return const Image(
                      height: 230,
                      width: 230,
                      image: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                    );
                  },
                  fit: BoxFit.cover,
                  image: NetworkImage((peopleMayYouKnowModel.profile_pic ?? '')
                      .formatedProfileUrl)),
            ),
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
                      'username': peopleMayYouKnowModel.username,
                      'isFromReels': 'false'
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 5),
                    child: Text(
                      '${peopleMayYouKnowModel.first_name ?? ''} ${peopleMayYouKnowModel.last_name ?? ''}',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('1 mutual friend'.tr,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 110,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 35,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: onPressedRemove,
                        child: Text('Remove'.tr,
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
