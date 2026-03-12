import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/string/string_image_path.dart';
import '../config/constants/app_assets.dart';
import '../modules/NAVIGATION_MENUS/friend/model/search_people_model.dart';
import '../routes/app_pages.dart';
import '../config/constants/color.dart';

class SearchPeopleCard extends StatelessWidget {
  const SearchPeopleCard({
    super.key,
    required this.peopleMayYouKnowModel,
    required this.onPressedAddFriend,
    required this.onPressedRemove,
  });
  final SearchPeopleModel peopleMayYouKnowModel;
  final VoidCallback onPressedAddFriend;
  final VoidCallback onPressedRemove;

  @override
  Widget build(BuildContext context) {
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
                image: NetworkImage((
                    peopleMayYouKnowModel.profile_pic ?? '').formatedProfileUrl)),
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
                    Get.toNamed(Routes.OTHERS_PROFILE,
                        arguments: {
                          'username':peopleMayYouKnowModel.username,
                          'isFromReels': 'false'
                        });
                  },
                  child: Text(
                    '${peopleMayYouKnowModel.first_name ?? ''} ${peopleMayYouKnowModel.last_name ?? ''}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('no mutual friend'.tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    peopleMayYouKnowModel.isFriendRequestSended == false ?
                    Container(
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
                    ) : Container(
                      height: 35,
                      width: 140,
                      decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: onPressedRemove,
                        child:  Text('Cancel Request'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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