import 'package:flutter/material.dart';
import '../../../../extension/string/string.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../components/image.dart';
import 'package:get/get.dart';

class LiveReelTopWidget extends StatelessWidget {
  /// pass [UserModel] to get the current user data
  // final UserIdModel? currentUser;

  /// tapping on the cross icon to end the live seassion
  final void Function() onLiveEnd;
  String? profilePic;
  String? firstName;
  String? lastName;
  final VoidCallback onTapProfileView;

  /// tapping on the follow
  final void Function() onTapFollow;
  final bool? hasFollow;

  /// how many user joined in live just pass the value
  final int joinUserCount;
  final int? reactionCount;

  LiveReelTopWidget(
      {
      // this.currentUser,
      this.profilePic,
      this.firstName,
      this.lastName,
      required this.onLiveEnd,
      required this.onTapFollow,
      required this.joinUserCount,
      this.reactionCount,
      super.key,
      required this.onTapProfileView,
      this.hasFollow});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // =========================== left section ============================
        Container(
          padding:
              const EdgeInsetsDirectional.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              InkWell(
                onTap: onTapProfileView,
                child: NetworkCircleAvatar(
                    radius: 18,
                    imageUrl: (profilePic ?? '').formatedProfileUrl),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onTapProfileView,
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            GetStringUtils('$firstName $lastName').capitalizeFirst!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 8),
                          Text('$reactionCount'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onTapFollow,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        hasFollow == true ? 'Followed' : 'Follow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        // =========================== right section ===========================
        Row(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 4, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    joinUserCount < 0 ? '0' : '$joinUserCount',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            const SizedBox(width: 2),
            IconButton(
                onPressed: onLiveEnd,
                icon: const Icon(Icons.clear, color: Colors.white, size: 20))
          ],
        )
      ],
    );
  }
}
