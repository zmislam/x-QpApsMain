// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../models/post.dart';
// import '../../routes/app_pages.dart';
// import 'post_body/post_body.dart';
// import 'post_footer/post_footer.dart';
// import 'post_header/group_post_header.dart';
// import 'post_header/page_post_header.dart';
// import 'post_header/post_header.dart';
// import 'post_header/share_reel_header.dart';
// import 'post_header/shared_post_header.dart';
//
// class PostCard extends StatelessWidget {
//   const PostCard(
//       {super.key,
//         required this.model,
//         required this.onSelectReaction,
//         required this.onPressedComment,
//         required this.onPressedShare,
//         required this.onTapBodyViewMoreMedia,
//         this.onTapEditPost,
//         this.onTapCopyPost,
//         this.onTapBookMardPost,
//         this.onTapRemoveBookMardPost,
//         this.onTapHidePost,
//         this.onTapViewOtherProfile,
//         this.onTapShareViewOtherProfile,
//         this.viewType,
//         this.onTapPinPost,
//         this.adVideoLink,
//         required this.onTapBlockUser,
//         this.onTapViewPostHistory,
//         required this.onTapViewReactions,
//         required this.onSixSeconds,
//         this.campaignWebUrl,
//         this.campaignName,
//         this.actionButtonText,
//         this.campaignDescription,
//         this.campaignCallToAction,
//         this.index});
//
//   final PostModel model;
//   final Function(String reaction) onSelectReaction;
//   final VoidCallback onPressedComment;
//   final VoidCallback onPressedShare;
//   final VoidCallback onTapBodyViewMoreMedia;
//   final VoidCallback onTapViewReactions;
//   final VoidCallback? onTapEditPost;
//   final VoidCallback onTapBlockUser;
//   final VoidCallback? onTapHidePost;
//   final VoidCallback? onTapBookMardPost;
//   final VoidCallback? onTapRemoveBookMardPost;
//   final VoidCallback? onTapViewOtherProfile;
//   final VoidCallback? onTapShareViewOtherProfile;
//   final VoidCallback? onTapCopyPost;
//   final VoidCallback? onTapViewPostHistory;
//   final VoidCallback? onTapPinPost;
//   final VoidCallback onSixSeconds;
//   final String? viewType;
//   final String? adVideoLink;
//   final String? campaignWebUrl;
//   final String? actionButtonText;
//   final String? campaignName;
//   final String? campaignDescription;
//   final VoidCallback? campaignCallToAction;
//
//   // ignore: prefer_typing_uninitialized_variables
//   final index;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.surface,
//       child: model.post_type == 'shared_reels'
//           ? Column(
//         children: [
//           SharedPostHeader(
//             model: model,
//             onTapEditPost: onTapEditPost ?? () {},
//             onTapCopyPost: onTapCopyPost ?? () {},
//           ),
//           const SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//             ),
//             child: Column(
//               children: [
//                 SharedReelHeader(
//                   model: model,
//                   onTapEditPost: onTapEditPost ?? () {},
//                 ),
//                 const SizedBox(height: 10),
//                 PostBodyView(
//                   adVideoLink: adVideoLink,
//                   actionButtonText: actionButtonText,
//                   campaignWebUrl: campaignWebUrl,
//                   campaignName: campaignName,
//                   campaignDescription: campaignDescription,
//                   campaignCallToAction: campaignCallToAction,
//                   onSixSeconds: onSixSeconds,
//                   model: model,
//                   onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           PostFooter(
//             model: model,
//             onSelectReaction: onSelectReaction,
//             onPressedComment: onPressedComment,
//             onPressedShare: onPressedShare,
//             onTapViewReactions: onTapViewReactions,
//           ),
//         ],
//       )
//           : model.post_type == 'Shared'
//           ? Column(
//         children: [
//           SharedPostHeader(
//             model: model,
//             onTapEditPost: onTapEditPost ?? () {},
//             onTapHidePost: onTapHidePost ?? () {},
//             onTapBookMarkPost: onTapBookMardPost ?? () {},
//             onTapCopyPost: onTapCopyPost ?? () {},
//           ),
//           const SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//             ),
//             child: Column(
//               children: [
//                 (model.share_post_id?.groupId?.groupName?.length ?? 0) > 1
//                     ? GroupPostHeader(
//                   onTapBlockUser: onTapBlockUser,
//                   model: model,
//                   onTapEditPost: onTapEditPost ?? () {},
//                   onTapViewPostHistory: onTapViewPostHistory ?? () {},
//                   onTapBookMarkPost: onTapBookMardPost ?? () {},
//                   onTapHidePost: onTapHidePost ?? () {},
//                   onTapCopyPost: onTapCopyPost ?? () {},
//                   viewType: viewType ?? '',
//                 )
//                     : model.share_post_id?.post_type == 'campaign'
//                     ? PagePostHeader(
//                   model: model,
//                   onTapEditPost: onTapEditPost ?? () {},
//                   onTapBookMarkPost: onTapBookMardPost ?? () {},
//                   onTapCopyPost: onTapCopyPost ?? () {},
//                   onTapViewPostHistory: () {
//                     Get.back();
//                     Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
//                   },
//                   onTapPinPost: onTapPinPost ?? () {},
//                   onTapRemoveBookMarkPost: () {
//                     onTapRemoveBookMardPost!();
//                   },
//                   viewType: viewType ?? '',
//                 )
//                     : (model.share_post_id?.page_id?.pageName?.length ?? 0) > 1
//                     ? PagePostHeader(
//                   model: model,
//                   onTapEditPost: onTapEditPost ?? () {},
//                   onTapBookMarkPost: onTapBookMardPost ?? () {},
//                   onTapCopyPost: onTapCopyPost ?? () {},
//                   onTapViewPostHistory: () {
//                     Get.back();
//                     Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
//                   },
//                   onTapPinPost: onTapPinPost ?? () {},
//                   onTapRemoveBookMarkPost: () {
//                     onTapRemoveBookMardPost!();
//                   },
//                   viewType: viewType ?? '',
//                 )
//                     : PostHeader(
//                   onTapBlockUser: onTapBlockUser,
//                   model: model,
//                   onTapEditPost: onTapEditPost ?? () {},
//                   onTapHidePost: onTapHidePost ?? () {},
//                   onTapBookMarkPost: onTapBookMardPost ?? () {},
//                   onTapCopyPost: onTapCopyPost ?? () {},
//                   onTapViewPostHistory: onTapViewPostHistory ?? () {},
//                   onTapPinPost: onTapPinPost ?? () {},
//                   onTapRemoveBookMarkPost: onTapRemoveBookMardPost ?? () {},
//                   viewType: viewType ?? '',
//                 ),
//                 const SizedBox(height: 10),
//                 PostBodyView(
//                   adVideoLink: adVideoLink,
//                   actionButtonText: actionButtonText,
//                   onSixSeconds: onSixSeconds,
//                   campaignWebUrl: campaignWebUrl,
//                   campaignName: campaignName,
//                   campaignDescription: campaignDescription,
//                   campaignCallToAction: campaignCallToAction,
//                   model: model,
//                   onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
//                   onTapShareViewOtherProfile: onTapShareViewOtherProfile,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           PostFooter(
//             model: model,
//             onSelectReaction: onSelectReaction,
//             onPressedComment: onPressedComment,
//             onPressedShare: onPressedShare,
//             onTapViewReactions: onTapViewReactions,
//           ),
//         ],
//       )
//           : Column(
//         children: [
//           model.groupId!.groupName!.length > 1
//               ? GroupPostHeader(
//             onTapBlockUser: onTapBlockUser,
//             model: model,
//             onTapEditPost: onTapEditPost ?? () {},
//             onTapViewPostHistory: onTapViewPostHistory ?? () {},
//             onTapBookMarkPost: onTapBookMardPost ?? () {},
//             onTapHidePost: onTapHidePost ?? () {},
//             onTapCopyPost: onTapCopyPost ?? () {},
//             viewType: viewType ?? '',
//           )
//               : model.page_id!.pageName!.length > 1
//               ? PagePostHeader(
//             model: model,
//             onTapEditPost: onTapEditPost ?? () {},
//             onTapBookMarkPost: onTapBookMardPost ?? () {},
//             onTapCopyPost: onTapCopyPost ?? () {},
//             onTapViewPostHistory: () {
//               Get.back();
//               Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
//             },
//             onTapPinPost: onTapPinPost ?? () {},
//             onTapRemoveBookMarkPost: () {
//               onTapRemoveBookMardPost!();
//             },
//             viewType: viewType ?? '',
//           )
//               : PostHeader(
//             onTapBlockUser: onTapBlockUser,
//             model: model,
//             onTapEditPost: onTapEditPost ?? () {},
//             onTapHidePost: onTapHidePost ?? () {},
//             onTapBookMarkPost: onTapBookMardPost ?? () {},
//             onTapCopyPost: onTapCopyPost ?? () {},
//             onTapViewPostHistory: onTapViewPostHistory ?? () {},
//             onTapPinPost: onTapPinPost ?? () {},
//             onTapRemoveBookMarkPost: onTapRemoveBookMardPost ?? () {},
//             viewType: viewType ?? '',
//           ),
//           const SizedBox(height: 10),
//           PostBodyView(
//             adVideoLink: adVideoLink,
//             actionButtonText: actionButtonText,
//             campaignWebUrl: campaignWebUrl,
//             campaignName: campaignName,
//             campaignDescription: campaignDescription,
//             campaignCallToAction: campaignCallToAction,
//             onSixSeconds: onSixSeconds,
//             model: model,
//             onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
//             onTapViewOtherProfile: onTapViewOtherProfile ?? () {},
//           ),
//           const SizedBox(height: 10),
//           PostFooter(
//             model: model,
//             onSelectReaction: onSelectReaction,
//             onPressedComment: onPressedComment,
//             onPressedShare: onPressedShare,
//             onTapViewReactions: onTapViewReactions,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget ReactionIcon(String assetName) {
//     return Image(height: 32, image: AssetImage(assetName));
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post.dart';
import '../../routes/app_pages.dart';
import 'post_body/post_body.dart';
import 'post_footer/post_footer.dart';
import 'post_header/group_post_header.dart';
import 'post_header/page_post_header.dart';
import 'post_header/post_header.dart';
import 'post_header/share_reel_header.dart';
import 'post_header/shared_post_header.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.model,
      required this.onSelectReaction,
      required this.onPressedComment,
      required this.onPressedShare,
      required this.onTapBodyViewMoreMedia,
      this.onTapEditPost,
      this.onTapCopyPost,
      this.onTapBookMardPost,
      this.onTapRemoveBookMardPost,
      this.onTapHidePost,
      this.onTapViewOtherProfile,
      this.onTapShareViewOtherProfile,
      this.viewType,
      this.onTapPinPost,
      this.adVideoLink,
      required this.onTapBlockUser,
      this.onTapViewPostHistory,
      required this.onTapViewReactions,
      required this.onSixSeconds,
      this.campaignWebUrl,
      this.campaignName,
      this.actionButtonText,
      this.campaignDescription,
      this.campaignCallToAction,
      this.index});

  final PostModel model;
  final Function(String reaction) onSelectReaction;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final VoidCallback onTapBodyViewMoreMedia;
  final VoidCallback onTapViewReactions;
  final VoidCallback? onTapEditPost;
  final VoidCallback onTapBlockUser;
  final VoidCallback? onTapHidePost;
  final VoidCallback? onTapBookMardPost;
  final VoidCallback? onTapRemoveBookMardPost;
  final VoidCallback? onTapViewOtherProfile;
  final VoidCallback? onTapShareViewOtherProfile;
  final VoidCallback? onTapCopyPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapPinPost;
  final VoidCallback onSixSeconds;
  final String? viewType;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? actionButtonText;
  final String? campaignName;
  final String? campaignDescription;
  final VoidCallback? campaignCallToAction;

  // ignore: prefer_typing_uninitialized_variables
  final index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: (model.user_id == null)
          ? SizedBox.shrink()
          : model.post_type == 'shared_reels'
              ? Column(
                  children: [
                    SharedPostHeader(
                      model: model,
                      onTapEditPost: onTapEditPost ?? () {},
                      onTapCopyPost: onTapCopyPost ?? () {},
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          SharedReelHeader(
                            model: model,
                            onTapEditPost: onTapEditPost ?? () {},
                          ),
                          const SizedBox(height: 10),
                          PostBodyView(
                            adVideoLink: adVideoLink,
                            actionButtonText: actionButtonText,
                            campaignWebUrl: campaignWebUrl,
                            campaignName: campaignName,
                            campaignDescription: campaignDescription,
                            campaignCallToAction: campaignCallToAction,
                            onSixSeconds: onSixSeconds,
                            model: model,
                            onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    PostFooter(
                      model: model,
                      onSelectReaction: onSelectReaction,
                      onPressedComment: onPressedComment,
                      onPressedShare: onPressedShare,
                      onTapViewReactions: onTapViewReactions,
                    ),
                  ],
                )
              : model.post_type == 'Shared'
                  ? Column(
                      children: [
                        SharedPostHeader(
                          model: model,
                          onTapEditPost: onTapEditPost ?? () {},
                          onTapHidePost: onTapHidePost ?? () {},
                          onTapBookMarkPost: onTapBookMardPost ?? () {},
                          onTapCopyPost: onTapCopyPost ?? () {},
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              (model.share_post_id?.groupId?.groupName
                                              ?.length ??
                                          0) >
                                      1
                                  ? GroupPostHeader(
                                      onTapBlockUser: onTapBlockUser,
                                      model: model,
                                      onTapEditPost: onTapEditPost ?? () {},
                                      onTapViewPostHistory:
                                          onTapViewPostHistory ?? () {},
                                      onTapBookMarkPost:
                                          onTapBookMardPost ?? () {},
                                      onTapHidePost: onTapHidePost ?? () {},
                                      onTapCopyPost: onTapCopyPost ?? () {},
                                      viewType: viewType ?? '',
                                    )
                                  : model.share_post_id?.post_type == 'campaign'
                                      ? PagePostHeader(
                                          model: model,
                                          onTapEditPost: onTapEditPost ?? () {},
                                          onTapBookMarkPost:
                                              onTapBookMardPost ?? () {},
                                          onTapCopyPost: onTapCopyPost ?? () {},
                                          onTapViewPostHistory: () {
                                            Get.back();
                                            Get.toNamed(Routes.EDIT_HISTORY,
                                                arguments: model.id);
                                          },
                                          onTapPinPost: onTapPinPost ?? () {},
                                          onTapRemoveBookMarkPost: () {
                                            onTapRemoveBookMardPost!();
                                          },
                                          viewType: viewType ?? '',
                                        )
                                      : (model.share_post_id?.page_id?.pageName
                                                      ?.length ??
                                                  0) >
                                              1
                                          ? PagePostHeader(
                                              model: model,
                                              onTapEditPost:
                                                  onTapEditPost ?? () {},
                                              onTapBookMarkPost:
                                                  onTapBookMardPost ?? () {},
                                              onTapCopyPost:
                                                  onTapCopyPost ?? () {},
                                              onTapViewPostHistory: () {
                                                Get.back();
                                                Get.toNamed(Routes.EDIT_HISTORY,
                                                    arguments: model.id);
                                              },
                                              onTapPinPost:
                                                  onTapPinPost ?? () {},
                                              onTapRemoveBookMarkPost: () {
                                                onTapRemoveBookMardPost!();
                                              },
                                              viewType: viewType ?? '',
                                            )
                                          : PostHeader(
                                              onTapBlockUser: onTapBlockUser,
                                              model: model,
                                              onTapEditPost:
                                                  onTapEditPost ?? () {},
                                              onTapHidePost:
                                                  onTapHidePost ?? () {},
                                              onTapBookMarkPost:
                                                  onTapBookMardPost ?? () {},
                                              onTapCopyPost:
                                                  onTapCopyPost ?? () {},
                                              onTapViewPostHistory:
                                                  onTapViewPostHistory ?? () {},
                                              onTapPinPost:
                                                  onTapPinPost ?? () {},
                                              onTapRemoveBookMarkPost:
                                                  onTapRemoveBookMardPost ??
                                                      () {},
                                              viewType: viewType ?? '',
                                            ),
                              const SizedBox(height: 10),
                              PostBodyView(
                                adVideoLink: adVideoLink,
                                actionButtonText: actionButtonText,
                                onSixSeconds: onSixSeconds,
                                campaignWebUrl: campaignWebUrl,
                                campaignName: campaignName,
                                campaignDescription: campaignDescription,
                                campaignCallToAction: campaignCallToAction,
                                model: model,
                                onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
                                onTapShareViewOtherProfile:
                                    onTapShareViewOtherProfile,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        PostFooter(
                          model: model,
                          onSelectReaction: onSelectReaction,
                          onPressedComment: onPressedComment,
                          onPressedShare: onPressedShare,
                          onTapViewReactions: onTapViewReactions,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        model.groupId!.groupName!.length > 1
                            ? GroupPostHeader(
                                onTapBlockUser: onTapBlockUser,
                                model: model,
                                onTapEditPost: onTapEditPost ?? () {},
                                onTapViewPostHistory:
                                    onTapViewPostHistory ?? () {},
                                onTapBookMarkPost: onTapBookMardPost ?? () {},
                                onTapHidePost: onTapHidePost ?? () {},
                                onTapCopyPost: onTapCopyPost ?? () {},
                                viewType: viewType ?? '',
                              )
                            : model.page_id!.pageName!.length > 1
                                ? PagePostHeader(
                                    model: model,
                                    onTapEditPost: onTapEditPost ?? () {},
                                    onTapBookMarkPost:
                                        onTapBookMardPost ?? () {},
                                    onTapCopyPost: onTapCopyPost ?? () {},
                                    onTapViewPostHistory: () {
                                      Get.back();
                                      Get.toNamed(Routes.EDIT_HISTORY,
                                          arguments: model.id);
                                    },
                                    onTapPinPost: onTapPinPost ?? () {},
                                    onTapRemoveBookMarkPost: () {
                                      onTapRemoveBookMardPost!();
                                    },
                                    viewType: viewType ?? '',
                                  )
                                : (model.user_id == null)
                                    ? SizedBox.shrink()
                                    : PostHeader(
                                        onTapBlockUser: onTapBlockUser,
                                        model: model,
                                        onTapEditPost: onTapEditPost ?? () {},
                                        onTapHidePost: onTapHidePost ?? () {},
                                        onTapBookMarkPost:
                                            onTapBookMardPost ?? () {},
                                        onTapCopyPost: onTapCopyPost ?? () {},
                                        onTapViewPostHistory:
                                            onTapViewPostHistory ?? () {},
                                        onTapPinPost: onTapPinPost ?? () {},
                                        onTapRemoveBookMarkPost:
                                            onTapRemoveBookMardPost ?? () {},
                                        viewType: viewType ?? '',
                                      ),
                        const SizedBox(height: 10),
                        PostBodyView(
                          adVideoLink: adVideoLink,
                          actionButtonText: actionButtonText,
                          campaignWebUrl: campaignWebUrl,
                          campaignName: campaignName,
                          campaignDescription: campaignDescription,
                          campaignCallToAction: campaignCallToAction,
                          onSixSeconds: onSixSeconds,
                          model: model,
                          onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
                          onTapViewOtherProfile: onTapViewOtherProfile ?? () {},
                        ),
                        const SizedBox(height: 10),
                        PostFooter(
                          model: model,
                          onSelectReaction: onSelectReaction,
                          onPressedComment: onPressedComment,
                          onPressedShare: onPressedShare,
                          onTapViewReactions: onTapViewReactions,
                        ),
                      ],
                    ),
    );
  }

  Widget ReactionIcon(String assetName) {
    return Image(height: 32, image: AssetImage(assetName));
  }
}
