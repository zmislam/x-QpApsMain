import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_cached_image_view.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../extension/date_time_extension.dart';
import '../../../routes/profile_navigator.dart';
import '../../video_player/post/newsfeed_post_video_player.dart';
import '../../video_player/post/post_details_video_screen.dart';
import '../../../extension/string/string_path.dart';
import '../../../utils/url_utils.dart';
import '../../../config/constants/app_assets.dart';
import '../../../models/share_post_id.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/media.dart';
import '../../../models/post.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/custom_widgets/custom_downloadable_text_widget.dart';
import '../../../modules/shared/modules/multiple_image/views/multiple_image_view.dart';
import '../../../routes/app_pages.dart';
import '../../../config/constants/color.dart';
import '../../../utils/file.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';
import '../../media/media_frame/media_component.dart';
import '../../single_image.dart';
import '../../media/media_grid/media_grid.dart';

part 'timeline_post.dart';
part 'shared_timeline_post.dart';
part 'live_video_post.dart';
part 'page_post.dart';
part 'profile_picture_post.dart';
part 'cover_picture_post.dart';
part 'event_post.dart';
part 'shared_reels_post.dart';
part 'birthday_post.dart';
part 'campain_post.dart';
part 'group_file_post.dart';
part 'shared_post.dart';
part 'post_body_utils.dart';

class PostBodyView extends StatelessWidget {
  /*
   * Post body view generator
   */

  final PostModel model;
  final VoidCallback onTapBodyViewMoreMedia;
  final VoidCallback? onTapViewOtherProfile;
  final VoidCallback? onTapShareViewOtherProfile;
  final VoidCallback onSixSeconds;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? actionButtonText;
  final String? campaignDescription;
  final VoidCallback? campaignCallToAction;

  const PostBodyView(
      {super.key,
      required this.model,
      this.adVideoLink,
      this.campaignWebUrl,
      this.actionButtonText,
      this.campaignName,
      this.campaignDescription,
      this.campaignCallToAction,
      required this.onTapBodyViewMoreMedia,
      this.onTapViewOtherProfile,
      required this.onSixSeconds,
      this.onTapShareViewOtherProfile});

  @override
  Widget build(BuildContext context) {
    switch (model.post_type) {
      case 'live':
        return LiveVideoPost(postModel: model);
      case 'timeline_post':
        return TimelinePost(
          campaignCallToAction: campaignCallToAction,
          campaignDescription: campaignDescription,
          campaignName: campaignName,
          campaignWebUrl: campaignWebUrl,
          actionButtonText: actionButtonText,
          onSixSeconds: onSixSeconds,
          adVideoLink: adVideoLink,
          postModel: model,
          onTapViewMoreMedia: onTapBodyViewMoreMedia,
          onTapViewOtherProfile: onTapViewOtherProfile ?? () {},
        );
      case 'page_post':
        return PagePost(
          postModel: model,
          onTapViewMoreMedia: onTapBodyViewMoreMedia,
          campaignCallToAction: campaignCallToAction,
          campaignDescription: campaignDescription,
          campaignName: campaignName,
          campaignWebUrl: campaignWebUrl,
          actionButtonText: actionButtonText,
          adVideoLink: adVideoLink,
        );
      case 'profile_picture':
        return ProfilePicturePost(postModel: model);
      case 'cover_picture':
        return CoverPicturePost(postModel: model);
      case 'event':
        return EventPost(postModel: model);
      case 'shared_reels':
        return SharedReelsPost(postModel: model);
      case 'birthday':
        return BirthdayPost(postModel: model);
      case 'campaign':
        return CampaignPost(postModel: model);
      case 'group_file':
        return GroupFilePost(postModel: model);
      case 'Shared':
        return SharedPost(
          postModel: model,
          onTapViewMoreMedia: onTapBodyViewMoreMedia,
          onTapShareViewOtherProfile: onTapShareViewOtherProfile ?? () {},
        );
      default:
        return Container();
    }
  }
}
