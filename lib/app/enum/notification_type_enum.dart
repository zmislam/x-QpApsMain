enum NotificationTypeEnum {
  SUPPORT_REPLY,
  ORDER_STATUS,
  ORDER_PLACED,
  ORDER_REFUND,
  ACCEPT_FRIEND_REQUEST,
  POST_COMMENTED,
  REPLY_COMMENT,
  COMMENT_REACTION,
  FOLLOW_REQUEST,
  FRIEND_REQUEST,
  PAGE_INVITATION,
  ACCEPT_INVITATION,
  GROUP_INVITATION,
  GROUP_JOINED,
  GROUP_JOINING,
  GROUP_JOINING_ACCEPT,
  GROUP_POST,
  ROLE_INVITATION,
  PAGE,
  PAGE_POST,
  PAGES,
  REEL_POST_REACTION,
  POST_REACTION,
  SHARED_POST,
  REEL_COMMENTED,
  CAMPAIGN,
  RECEIVED_MONEY,
  SHARED_REELS_POST,
  POST_TAGS,
  MONETIZATION,
  REPORT_ACTION,
  CHECK_IN,
  PAGE_LIKE,
  MENTION,
  UNKNOWN;

  static NotificationTypeEnum fromString(String? value) {
    switch (value) {
      case 'support_reply':
        return NotificationTypeEnum.SUPPORT_REPLY;
      case 'order_status':
        return NotificationTypeEnum.ORDER_STATUS;
      case 'order_placed':
        return NotificationTypeEnum.ORDER_PLACED;
      case 'order_refund':
        return NotificationTypeEnum.ORDER_REFUND;
      case 'accept_friend_request':
        return NotificationTypeEnum.ACCEPT_FRIEND_REQUEST;
      case 'post_commented':
        return NotificationTypeEnum.POST_COMMENTED;
      case 'reply_comment':
        return NotificationTypeEnum.REPLY_COMMENT;
      case 'comment_reaction':
        return NotificationTypeEnum.COMMENT_REACTION;
      case 'follow_request':
        return NotificationTypeEnum.FOLLOW_REQUEST;
      case 'friend_request':
        return NotificationTypeEnum.FRIEND_REQUEST;
      case 'page_invitation':
        return NotificationTypeEnum.PAGE_INVITATION;
      case 'accept_invitation':
        return NotificationTypeEnum.ACCEPT_INVITATION;
      case 'group_invitation':
        return NotificationTypeEnum.GROUP_INVITATION;
      case 'group_joined':
        return NotificationTypeEnum.GROUP_JOINED;
      case 'group_joining':
        return NotificationTypeEnum.GROUP_JOINING;
      case 'group_joining_accept':
        return NotificationTypeEnum.GROUP_JOINING_ACCEPT;
      case 'group_post':
        return NotificationTypeEnum.GROUP_POST;
      case 'role_invitation':
        return NotificationTypeEnum.ROLE_INVITATION;
      case 'page':
        return NotificationTypeEnum.PAGE;
      case 'page_post':
        return NotificationTypeEnum.PAGE_POST;
      case 'pages':
        return NotificationTypeEnum.PAGES;
      case 'reel_post_reaction':
        return NotificationTypeEnum.REEL_POST_REACTION;
      case 'shared_reels_post':
        return NotificationTypeEnum.SHARED_REELS_POST;
      case 'post_reaction':
        return NotificationTypeEnum.POST_REACTION;
      case 'shared_post':
        return NotificationTypeEnum.SHARED_POST;
      case 'reel_commented':
        return NotificationTypeEnum.REEL_COMMENTED;
      case 'campaign':
        return NotificationTypeEnum.CAMPAIGN;
      case 'received_money':
        return NotificationTypeEnum.RECEIVED_MONEY;
      case 'post_tags':
        return NotificationTypeEnum.POST_TAGS;
      case 'monetization':
        return NotificationTypeEnum.MONETIZATION;
      case 'report_action':
        return NotificationTypeEnum.REPORT_ACTION;
      case 'check_in':
        return NotificationTypeEnum.CHECK_IN;
      case 'page_like':
        return NotificationTypeEnum.PAGE_LIKE;
      case 'mention':
        return NotificationTypeEnum.MENTION;
      default:
        return NotificationTypeEnum.UNKNOWN;
    }
  }

  /// Whether this notification type supports inline action buttons
  bool get hasActionButtons {
    return this == FRIEND_REQUEST ||
        this == GROUP_INVITATION ||
        this == GROUP_JOINING ||
        this == PAGE_INVITATION;
  }
}
