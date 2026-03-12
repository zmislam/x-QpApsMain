// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/extension/date_time_extension.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../config/constants/app_assets.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.model,
  });
  final NotificationModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (model.notification_seen ?? false)
            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.0)
            : Theme.of(context).colorScheme.onInverseSurface,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              RoundCornerNetworkImage(
                imageUrl: (model.notification_sender_id?.profile_pic ?? '')
                    .formatedProfileUrl,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Image.asset(
                    getIconPath(model),
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: model.notification_type == 'campaign' ||
                            model.notification_type == 'monetization' ||
                            model.notification_type == 'report_action'
                        ? ''
                        : model.notification_type == 'support_reply'
                            ? 'QP Admin '
                            : '${model.notification_sender_id?.first_name} ${model.notification_sender_id?.last_name} ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                      text: getTextAsNotificationType(model),
                      style: Theme.of(context).textTheme.bodyMedium)
                ])),
                Text(
                  timeago.format(
                    DateTime.parse(model.createdAt ?? DateTime.now().toIso8601String()),
                  ),
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTextAsNotificationType(NotificationModel model) {
    switch (model.notification_type) {
      case 'post_reaction':
        return 'has reacted on your post';
      case 'post_commented':
        return 'has commented on your post';
      case 'shared_reels_post':
        return 'has shared your reel';
      case 'reel_post_reaction':
        return 'has reacted on your reel';
      case 'reel_commented':
        return 'has commented on your reel';
      case 'reply_comment':
        return 'has reply on your comment';
      case 'comment_reaction':
        return 'has reacted on your comment';
      case 'follow_request':
        return 'is following you';
      case 'friend_request':
        return 'sent you friend request';
      case 'accept_friend_request':
        return 'accept your friend request';
      case 'page_invitation':
        return 'has invited ${model.resourceObject?.pageName} page';
      case 'page':
        return '${model.message}';
      case 'page_post':
        return '${model.message}';
      case 'pages':
        return '${model.message}';
      case 'group_invitation':
        return 'has invited to join ${model.resourceObject?.groupName} group';
      case 'group_post':
        return 'has posted in ${model.resourceObject?.groupName} group';
      case 'group_joined':
        return 'has joined ${model.resourceObject?.groupName} group';
      case 'group_joining':
        return 'has sent a join request to ${model.resourceObject?.groupName} group';
      case 'group_joining_accept':
        return 'accept your ${model.resourceObject?.groupName} group invitation';
      case 'received_money':
        return 'has sent ${model.message} QP dollar on your wallet';
      case 'campaign':
        return '${model.message}';
      case 'report_action':
        return '${model.message}';
      case 'monetization':
        return '${model.message}';
      case 'support_reply':
        return '${model.message}';
      case 'order_placed':
        return '${model.message}';
      case 'order_status':
        return '${model.message}';
      case 'order_refund':
        return '${model.message}';
      case 'shared_post':
        return 'has shared your post';
      case 'accept_invitation':
        return 'has accepted your page invitation';
      case 'role_invitation':
        return '${model.message}';
      case 'post_tags':
        return 'has tagged you in a post';
      default:
        return 'Notification type not found';
    }
  }

  String getIconPath(NotificationModel model) {
    switch (model.notification_type) {
      case 'post_reaction':
        return getReactionIconPath(model.notification_data?.reactionType ?? '');
      case 'post_commented':
        return AppAssets.COMMENT_ICON;
      case 'support_reply':
        return AppAssets.COMMENT_ICON;
      case 'reel_comment':
        return AppAssets.COMMENT_ICON;
      case 'reply_comment':
        return AppAssets.COMMENT_ICON;
      case 'order_status':
        return AppAssets.ORDER_STATUS_ICON;
      case 'order_placed':
        return AppAssets.ORDER_STATUS_ICON;
      case 'order_refund':
        return AppAssets.REFUND_ICON;
      case 'reel_post_reaction':
        return getReactionIconPath(model.notification_data?.reactionType ?? '');
      case 'comment_reaction':
        return getReactionIconPath(model.notification_data?.reactionType ?? '');
      case 'follow_request':
        return AppAssets.FRIEND_REQUEST_ICON;
      case 'friend_request':
        return AppAssets.FRIEND_REQUEST_ICON;
      case 'accept_friend_request':
        return AppAssets.FRIEND_REQUEST_ICON;
      case 'page_invitation':
        return AppAssets.PAGE_INVITE_ICON;
      case 'accept_invitation':
        return AppAssets.PAGE_INVITE_ICON;
      case 'page':
        return AppAssets.PAGE_INVITE_ICON;
      case 'page_post':
        return AppAssets.PAGE_INVITE_ICON;
      case 'group_invitation':
        return AppAssets.GROUP_ICON;
      case 'group_joining':
        return AppAssets.GROUP_ICON;
      case 'group_joined':
        return AppAssets.GROUP_ICON;
      case 'group_joining_accept':
        return AppAssets.GROUP_ICON;
      case 'group_post':
        return AppAssets.GROUP_ICON;
      case 'campaign':
        return AppAssets.CAMPAIGN_ICON;
      case 'monetization':
        return AppAssets.CAMPAIGN_ICON;
      case 'received_money':
        return AppAssets.RECEIVE_MONEY_ICON;
      case 'shared_post':
        return AppAssets.SHARE_ICON;
      default:
        return AppAssets.PAGE_INVITE_ICON;
    }
  }

  String getReactionIconPath(reactionType) {
    switch (reactionType) {
      case 'love':
        return AppAssets.LOVE_ICON;
      case 'angry':
        return AppAssets.ANGRY_ICON;
      case 'haha':
        return AppAssets.HAHA_ICON;
      case 'sad':
        return AppAssets.SAD_ICON;
      case 'like':
        return AppAssets.LIKE_ICON;
      default:
        return AppAssets.LOVE_ICON;
    }
  }
}
