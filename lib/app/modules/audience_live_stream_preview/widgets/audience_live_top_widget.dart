import 'package:flutter/material.dart';
import '../../../components/image.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/user.dart';
import '../../../models/user_id.dart';
import 'package:get/get.dart';

class AudienceLiveTopWidget extends StatelessWidget {
  /// pass [UserModel] to get the current user data
  final UserIdModel? currentUser;

  /// tapping on the cross icon to end the live seassion
  final void Function() onLiveEnd;

  /// tapping on the follow
  final void Function() onTapFollow;

  /// how many user joined in live just pass the value
  final int joinUserCount;

  /// reaction count
  final int reactionCount;

  final bool? hasFollow;

  final VoidCallback onTapProfileView;

  const AudienceLiveTopWidget(
      {this.currentUser,
      required this.onLiveEnd,
      required this.onTapFollow,
      this.joinUserCount = 0,
      this.reactionCount = 0,
      this.hasFollow,
      required this.onTapProfileView,
      super.key});

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
                    imageUrl:
                        '${ApiConstant.SERVER_IP_PORT}/uploads/${currentUser?.profile_pic ?? ''}'),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${currentUser?.first_name ?? ''} ${currentUser?.last_name ?? ''}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 8),
                          Text('$reactionCount'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 2),
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
                        style: const TextStyle(
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
                    style: const TextStyle(
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
