import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/NAVIGATION_MENUS/reels/model/reels_comment_model.dart';
import '../image.dart';
import '../../config/constants/api_constant.dart';

class ReelsLiveStreamComment extends StatelessWidget {
  final List<ReelsCommentModel> commentList;
  final ScrollController scrollController;
  const ReelsLiveStreamComment(
      {required this.commentList, required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: Get.width,
      child: ListView.separated(
        reverse: true,
        shrinkWrap: true,
        controller: scrollController,
        itemCount: commentList.length,
        padding: const EdgeInsets.only(left: 12, right: 12),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          ReelsCommentModel model = commentList[index];

          return Row(
            children: [
              // ====================== commented user image =================
              NetworkCircleAvatar(
                  radius: 16,
                  imageUrl:
                      '${ApiConstant.SERVER_IP_PORT}/uploads/${model.user_id?.profile_pic ?? ''}'),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= commented user name ============
                    Text(
                      '${model.user_id?.first_name ?? ''} ${model.user_id?.last_name ?? ''}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      model.comment_name ?? '',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
