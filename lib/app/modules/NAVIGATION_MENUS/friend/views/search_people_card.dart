import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../routes/app_pages.dart';
import '../../../../config/constants/app_assets.dart';
import '../model/search_people_model.dart';

class SearchPeopleCard extends StatelessWidget {
  static const PRIMARY_COLOR = Color(0xff307777);

  const SearchPeopleCard({
    super.key,
    required this.searchPeopleModel,
    required this.onPressedAddFriend,
  });

  final SearchPeopleModel searchPeopleModel;
  final VoidCallback onPressedAddFriend;

  @override
  Widget build(BuildContext context) {
    // FriendController controller = Get.find();

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
                    (searchPeopleModel.profile_pic ?? '').formatedProfileUrl)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                      'username': searchPeopleModel.username.toString(),
                      'isFromReels': 'false'
                    });
                  },
                  child: Text(
                    '${searchPeopleModel.first_name ?? ''} ${searchPeopleModel.last_name ?? ''}',
                    style: TextStyle(
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
                (searchPeopleModel.isFriendRequestSended ?? false)
                    ? Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Cancel'.tr,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    : Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: onPressedAddFriend,
                          child: Text('Add Friend'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
