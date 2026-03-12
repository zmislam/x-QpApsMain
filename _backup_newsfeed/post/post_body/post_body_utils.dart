part of 'post_body.dart';

String getDynamicFormatedTime(String time) {
  // print("time of date ........."+time);

  DateTime postDateTime;
  if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
    postDateTime = DateTime.now().toLocal();
  } else {
    postDateTime = DateTime.parse(time).toLocal();
  }
  return productDateTimeFormat.format(postDateTime);
}

String getSharedEducationEventText(PostModel postModel) {
  return postModel.share_post_id!.event_sub_type!.contains('New School')
      ? 'Started School at ${postModel.share_post_id?.institute_id?.instituteName}'
      : postModel.share_post_id!.event_sub_type!.contains('Graduate')
          ? 'Graduated from ${postModel.share_post_id?.institute_id?.instituteName}'
          : 'Left School from ${postModel.share_post_id?.institute_id?.instituteName}';
}

String getEducationEventText(PostModel postModel) {
  return postModel.event_sub_type!.contains('New School')
      ? 'Started School at ${postModel.institute_id?.instituteName}'
      : postModel.event_sub_type!.contains('Graduate')
          ? 'Graduated from ${postModel.institute_id?.instituteName}'
          : 'Left School from ${postModel.institute_id?.instituteName}';
}

String getRelationEventText(PostModel postModel) {
  return postModel.event_sub_type!.contains('New Relationship')
      ? 'In a relationship with ${postModel.lifeEventId?.toUserId?.firstName} ${postModel.lifeEventId?.toUserId?.lastName}'
      : postModel.event_sub_type!.contains('Engagement')
          ? 'Engaged to ${postModel.lifeEventId?.toUserId?.firstName} ${postModel.lifeEventId?.toUserId?.lastName}'
          : postModel.event_sub_type!.contains('Marriage')
              ? 'Married to ${postModel.lifeEventId?.toUserId?.firstName} ${postModel.lifeEventId?.toUserId?.lastName}'
              : 'First Meet ${postModel.lifeEventId?.toUserId?.firstName} ${postModel.lifeEventId?.toUserId?.lastName} ';
}

String getSharedRelationEventText(PostModel postModel) {
  return postModel.share_post_id!.event_sub_type!.contains('New Relationship')
      ? 'In a relationship with ${postModel.share_post_id?.lifeEventId?.toUserId?.firstName} ${postModel.share_post_id?.lifeEventId?.toUserId?.lastName}'
      : postModel.share_post_id!.event_sub_type!.contains('Engagement')
          ? 'Engaged to ${postModel.share_post_id?.lifeEventId?.toUserId?.firstName} ${postModel.share_post_id?.lifeEventId?.toUserId?.lastName}'
          : postModel.share_post_id!.event_sub_type!.contains('Marriage')
              ? 'Married to ${postModel.share_post_id?.lifeEventId?.toUserId?.firstName} ${postModel.share_post_id?.lifeEventId?.toUserId?.lastName}'
              : 'First Meet ${postModel.share_post_id?.lifeEventId?.toUserId?.firstName} ${postModel.share_post_id?.lifeEventId?.toUserId?.lastName} ';
}

String getTravelEventText(PostModel postModel) {
  return 'Travel to ${postModel.lifeEventId?.locationName}';
}

String getSharedTravelEventText(PostModel postModel) {
  return 'Travel to ${postModel.share_post_id?.lifeEventId?.locationName}';
}

String getMilestonEventText(PostModel postModel) {
  return '${postModel.lifeEventId?.title}';
}

String getSharedMilestonEventText(PostModel postModel) {
  return '${postModel.share_post_id?.lifeEventId?.title}';
}

String getCustomEventText(PostModel postModel) {
  return '${postModel.lifeEventId?.title}';
}

String getSharedCustomEventText(PostModel postModel) {
  return '${postModel.share_post_id?.lifeEventId?.title}';
}

String getWorkEventText(PostModel postModel) {
  return postModel.event_sub_type!.contains('New Job')
      ? 'Started New Job at ${postModel.workplace_id?.orgName} as ${postModel.workplace_id?.designation}'
      : postModel.event_sub_type!.contains('Promotion')
          ? 'Promoted Job at ${postModel.workplace_id?.orgName} as ${postModel.workplace_id?.designation}'
          : postModel.event_sub_type!.contains('Left Job')
              ? 'Left Job from ${postModel.workplace_id?.orgName} as ${postModel.workplace_id?.designation}'
              : 'Retirement from ${postModel.workplace_id?.orgName} as ${postModel.workplace_id?.designation}';
}

String getSharedWorkEventText(PostModel postModel) {
  return postModel.share_post_id!.event_sub_type!.contains('New Job')
      ? 'Started New Job at ${postModel.share_post_id?.workplace_id?.orgName} as ${postModel.share_post_id?.workplace_id?.designation}'
      : postModel.share_post_id!.event_sub_type!.contains('Promotion')
          ? 'Promoted Job at ${postModel.share_post_id?.workplace_id?.orgName} as ${postModel.share_post_id?.workplace_id?.designation}'
          : postModel.share_post_id!.event_sub_type!.contains('Left Job')
              ? 'Left Job from ${postModel.share_post_id!.workplace_id?.orgName} as ${postModel.share_post_id?.workplace_id?.designation}'
              : 'Retirement from ${postModel.share_post_id?.workplace_id?.orgName} as ${postModel.share_post_id?.workplace_id?.designation}';
}

String getCustomLifeEventIconName(String iconName) {
  return 'assets/icon/live_event/$iconName${'.png'}';
}

Widget getEventIcon(
  PostModel model, {
  double height = 60,
  double width = 60,
}) {
  switch (model.event_type) {
    case 'education':
      return Image.asset(
        'assets/icon/live_event/education_event_icon.png',
        width: width,
        height: height,
      );
    case 'work':
      return Image.asset(
        'assets/icon/live_event/work_event_icon.png',
        width: width,
        height: height,
      );
    case 'travel':
      return Image.asset(
        'assets/icon/live_event/travel_icon.png',
        width: width,
        height: height,
      );
    case 'customevent':
      return Image.asset(
        getCustomLifeEventIconName(model.lifeEventId?.iconName ?? ''),
        width: width,
        height: height,
      );
    case 'milestonesandachievements':
      return Image.asset(
        'assets/icon/live_event/mileston_icon.png',
        width: width,
        height: height,
      );
    case 'relationship':
      return model.event_sub_type == 'New Relationship'
          ? Image.asset(
              'assets/icon/live_event/in_relation_icon.png',
              width: width,
              height: height,
            )
          : model.event_sub_type == 'Engagement'
              ? Image.asset(
                  'assets/icon/live_event/engaged_icon.png',
                  width: width,
                  height: height,
                )
              : model.event_sub_type == 'Marriage'
                  ? Image.asset(
                      'assets/icon/live_event/marraid_icon.png',
                      width: width,
                      height: height,
                    )
                  : Image.asset(
                      'assets/icon/live_event/first_meet_icon.png',
                      width: width,
                      height: height,
                    );
    default:
      return Image.asset(
        'assets/icon/live_event/education_event_icon.png',
        width: width,
        height: height,
      );
  }
}

Widget getSharedEventIcon(
  PostModel model, {
  double height = 60,
  double width = 60,
}) {
  switch (model.share_post_id?.event_type) {
    case 'education':
      return Image.asset(
        'assets/icon/live_event/education_event_icon.png',
        width: width,
        height: height,
      );
    case 'work':
      return Image.asset(
        'assets/icon/live_event/work_event_icon.png',
        width: width,
        height: height,
      );
    case 'travel':
      return Image.asset(
        'assets/icon/live_event/travel_icon.png',
        width: width,
        height: height,
      );
    case 'customevent':
      return Image.asset(
        getCustomLifeEventIconName(
            model.share_post_id?.lifeEventId?.iconName ?? ''),
        width: width,
        height: height,
      );
    case 'milestonesandachievements':
      return Image.asset(
        'assets/icon/live_event/mileston_icon.png',
        width: width,
        height: height,
      );
    case 'relationship':
      return model.share_post_id?.event_sub_type == 'New Relationship'
          ? Image.asset(
              'assets/icon/live_event/in_relation_icon.png',
              width: width,
              height: height,
            )
          : model.share_post_id?.event_sub_type == 'Engagement'
              ? Image.asset(
                  'assets/icon/live_event/engaged_icon.png',
                  width: width,
                  height: height,
                )
              : model.share_post_id?.event_sub_type == 'Marriage'
                  ? Image.asset(
                      'assets/icon/live_event/marraid_icon.png',
                      width: width,
                      height: height,
                    )
                  : Image.asset(
                      'assets/icon/live_event/first_meet_icon.png',
                      width: width,
                      height: height,
                    );
    default:
      return Image.asset(
        'assets/icon/live_event/education_event_icon.png',
        width: width,
        height: height,
      );
  }
}

bool isMediaListContainVideoUrl(List<MediaModel>? media) {
  if (media == null || media.isEmpty) {
    return false;
  }
  for (MediaModel mediaModel in media) {
    if (!isImageUrl(mediaModel.media ?? '')) {
      return true;
    }
  }
  return false;
}
