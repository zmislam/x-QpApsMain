import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../components/reels_component.dart';
import '../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../../../../utils/bottom_sheet.dart';
import '../../../../../../utils/loader.dart';
import '../../../../user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../components/reels_comment_component.dart';
import '../../../model/reels_model.dart';
import '../../../model/reels_reacted_user_model.dart';
import '../controllers/suggested_reels_controller.dart';

/// Full-screen vertical viewer for suggested reels opened from
/// the newsfeed suggestion card.
///
/// Reuses [ReelsComponent] for each reel. The queue is finite
/// (typically 5 reels per suggestion card) — no infinite scroll.
class SuggestedReelsView extends GetView<SuggestedReelsController> {
  const SuggestedReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SuggestedReelsViewBody(controller: controller);
  }
}

class _SuggestedReelsViewBody extends StatefulWidget {
  final SuggestedReelsController controller;
  const _SuggestedReelsViewBody({required this.controller});

  @override
  State<_SuggestedReelsViewBody> createState() =>
      _SuggestedReelsViewBodyState();
}

class _SuggestedReelsViewBodyState extends State<_SuggestedReelsViewBody> {
  Worker? _loadingWorker;
  bool _isLoaderShown = false;

  @override
  void initState() {
    super.initState();
    _loadingWorker = ever(widget.controller.isLoading, (bool loading) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (loading && !_isLoaderShown) {
          _isLoaderShown = true;
          showLoader();
        } else if (!loading && _isLoaderShown) {
          _isLoaderShown = false;
          dismissLoader();
        }
      });
    });
  }

  @override
  void dispose() {
    _loadingWorker?.dispose();
    if (_isLoaderShown) {
      dismissLoader();
      _isLoaderShown = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Obx(() {
          final reelsList = widget.controller.reelsModelList.value;

          if (widget.controller.isLoading.value) {
            return const Center(child: SizedBox.shrink());
          }

          if (reelsList.isEmpty) {
            return const Center(
              child: Text(
                'No reels available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Stack(
            children: [
              // ─── Vertical Page View ──────────────────────────────────
              PageView.builder(
                controller: widget.controller.pageController,
                scrollDirection: Axis.vertical,
                itemCount: reelsList.length + 1, // +1 for end card
                onPageChanged: (int index) {
                  widget.controller.currentPageIndex = index;
                  
                  // If on the end card (last page)
                  if (index == reelsList.length) {
                    widget.controller.onEndCardViewed();
                  } else {
                    widget.controller.onLeftEndCard();
                    final reel = reelsList[index];
                    widget.controller.onReelViewed(reel.id ?? '', index);
                  }
                },
                itemBuilder: (context, index) {
                  // End card page
                  if (index == reelsList.length) {
                    return _buildEndCard(context);
                  }
                  
                  return Obx(() {
                    final reel = widget.controller.reelsModelList.value[index];
                    final myId =
                        widget.controller.loginCredential.getUserData().id;
                    final bool isLiked = (reel.reactions ?? []).any((r) {
                      try {
                        return (r.reacted_user?.id == myId) ||
                            (r.user_id?.id == myId);
                      } catch (_) {
                        return false;
                      }
                    });

                    return ReelsComponent(
                      // ── Delete ──
                      onTapDelete: () async {
                        showDeleteAlertDialogs(
                          context: context,
                          deletingItemType: 'Reel',
                          onDelete: () {
                            widget.controller
                                .deleteReels(reel.id ?? '', reel.key ?? '');
                          },
                          onCancel: () => Get.back(),
                        );
                      },

                      // ── Report ──
                      onPressedReport: () async {
                        await widget.controller.getReports();
                        CustomReportBottomSheet.showReportOptions(
                          context: context,
                          pageReportList:
                              widget.controller.pageReportList.value,
                          selectedReportType:
                              widget.controller.selectedReportType,
                          selectedReportId: widget.controller.selectedReportId,
                          reportDescription: widget.controller.reportDescription,
                          onCancel: () => Get.back(),
                          reportAction: (String reportTypeId,
                              String reportType,
                              String pageId,
                              String description) {
                            widget.controller.reportRepository.reportAPost(
                              id_key: 'post_id',
                              report_type: reportType,
                              description: description,
                              post_id: reel.id ?? '',
                              report_type_id: reportTypeId,
                            );
                          },
                        );
                      },

                      loginCredentials: widget.controller.loginCredential,

                      // ── View Profile ──
                      onPressedViewProfile: () {
                        ProfileNavigator.navigateToProfile(
                          username: reel.reel_user?.username ?? '',
                          isFromReels: 'false',
                        );
                      },

                      // ── Share ──
                      onPressedShareReels: () {
                        showDraggableScrollableBottomSheet(
                          context,
                          child: ShareSheetWidget(
                            userId: reel.reel_user?.id ?? '',
                            reelsId: reel.id ?? '',
                            report_id_key: 'reel_id',
                          ),
                        );
                      },

                      // ── View Reactions ──
                      onPressedViewReact: () {
                        Get.toNamed(Routes.REELS_REACTIONS,
                            arguments: reel.id);
                      },

                      isLiked: isLiked,
                      carouselController: CarouselController(),
                      reelsModel: reel,

                      // ── Reaction ──
                      onPressedReaction: (String reactionType) {
                        final reelsIndex = widget
                            .controller.reelsModelList.value
                            .indexWhere((r) => r.id == reel.id);
                        if (reelsIndex == -1) return;
                        widget.controller.reelsReaction(
                            reel.id ?? '', reelsIndex, reactionType);
                      },

                      // ── Like ──
                      onPressedLike: () {
                        final reelsIndex = widget
                            .controller.reelsModelList.value
                            .indexWhere((r) => r.id == reel.id);
                        if (reelsIndex == -1) return;

                        final current =
                            widget.controller.reelsModelList.value[reelsIndex];
                        final myId =
                            widget.controller.loginCredential.getUserData().id;

                        final bool alreadyLiked =
                            (current.reactions ?? []).any((r) {
                          try {
                            return (r.reacted_user?.id == myId) ||
                                (r.user_id?.id == myId);
                          } catch (_) {
                            return false;
                          }
                        });

                        final int updatedCount =
                            (current.reaction_count ?? 0) +
                                (alreadyLiked ? -1 : 1);

                        List<ReelsReactionModel> newReactions =
                            List<ReelsReactionModel>.from(
                                current.reactions ?? []);

                        if (!alreadyLiked) {
                          newReactions.insert(
                            0,
                            ReelsReactionModel(
                              reacted_user:
                                  ReelsReactedUserIdModel(id: myId),
                              reaction_type: 'like',
                            ),
                          );
                        } else {
                          newReactions = newReactions.where((r) {
                            try {
                              return !(r.reacted_user?.id == myId ||
                                  r.user_id?.id == myId);
                            } catch (_) {
                              return true;
                            }
                          }).toList();
                        }

                        final updatedModel = current.copyWith(
                          reaction_count: updatedCount,
                          reactions: newReactions,
                        );

                        final updatedList = List<ReelsModel>.from(
                            widget.controller.reelsModelList.value);
                        updatedList[reelsIndex] = updatedModel;
                        widget.controller.reelsModelList.value = updatedList;

                        widget.controller
                            .reelsLike(reel.id ?? '', reelsIndex);
                      },

                      // ── Comment ──
                      onPressedComment: () {
                        widget.controller
                            .getReelCommentList(reel.id ?? '');

                        Get.bottomSheet(
                          Obx(() => ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            child: ReelsCommentComponent(
                              reelsCommentList: widget
                                  .controller.reelsCommentModelList.value,
                              reelsModel: reel,
                              onTapViewReactions: () {
                                Get.toNamed(Routes.REELS_REACTIONS,
                                    arguments: reel.id);
                              },
                              onTapSendReelsComment: () {
                                widget.controller.reelsComments(
                                  reel.id ?? '',
                                  widget.controller.reelsCommentController.text,
                                  index,
                                  reel.key ?? '',
                                );
                                widget.controller.reelsCommentController
                                    .clear();
                              },
                              reelsCommentController:
                                  widget.controller.reelsCommentController,
                              userModel: widget.controller.loginCredential
                                  .getUserData(),
                              onTapReelsReplayComment: ({
                                required commentReplay,
                                required comment_id,
                                required file,
                              }) {
                                widget.controller.reelsCommentsReply(
                                  comment_id: comment_id,
                                  replies_comment_name: commentReplay,
                                  post_id: reel.id ?? '',
                                  replies_user_id: widget
                                          .controller.loginCredential
                                          .getUserData()
                                          .id ??
                                      '',
                                  file: file,
                                  key: reel.key ?? '',
                                );
                              },
                              onSelectReelsCommentReplayReaction:
                                  (String reaction,
                                      String commentId,
                                      String commentRepliesId,
                                      String userId) {
                                widget.controller.reelsReplyCommentReaction(
                                  reactionType: reaction,
                                  post_id: reel.id ?? '',
                                  comment_id: commentId,
                                  comment_reply_id: commentRepliesId,
                                  userId: userId,
                                );
                              },
                              onReelsCommentEdit: (reelsCommentModel) async {
                                await Get.toNamed(
                                  Routes.EDIT_REELS_COMMENT,
                                  arguments: {
                                    'post_comment':
                                        reelsCommentModel.comment_name,
                                    'post_id': reelsCommentModel.post_id,
                                    'comment_id': reelsCommentModel.id,
                                    'comment_type':
                                        reelsCommentModel.comment_type,
                                    'image_video':
                                        reelsCommentModel.image_or_video,
                                    'key': reelsCommentModel.key,
                                  },
                                );
                                widget.controller.getReelCommentList(
                                    reelsCommentModel.post_id ?? '');
                              },
                              onReelsCommentDelete: (reelsCommentModel) {
                                widget.controller.reelsCommentDelete(
                                  reelsCommentModel.id ?? '',
                                  reelsCommentModel.post_id ?? '',
                                  index,
                                  reelsCommentModel.key ?? '',
                                );
                              },
                              onReelsCommentReplayEdit:
                                  (reelsCommentReplyModel) async {
                                await Get.toNamed(
                                  Routes.EDIT_REELS_REPLY_COMMENT,
                                  arguments: {
                                    'reply_comment': reelsCommentReplyModel
                                        .replies_comment_name,
                                    'replay_post_id':
                                        reelsCommentReplyModel.post_id,
                                    'comment_replay_id':
                                        reelsCommentReplyModel.id,
                                    'comment_type':
                                        reelsCommentReplyModel.comment_type,
                                    'image_video':
                                        reelsCommentReplyModel.image_or_video,
                                    'key': reelsCommentReplyModel.key,
                                  },
                                );
                                widget.controller.getReelCommentList(
                                    reelsCommentReplyModel.post_id ?? '');
                              },
                              onReelsCommentReplayDelete:
                                  (replyId, postId, key) {
                                widget.controller.reelsCommentReplyDelete(
                                    replyId, postId, index, key);
                              },
                              onSelectReelsCommentReaction:
                                  (reaction, reelsCommentModel) {
                                widget.controller.reelsCommentReaction(
                                  reactionType: reaction,
                                  post_id: reel.id ?? '',
                                  comment_id: reelsCommentModel.id ?? '',
                                  userId:
                                      reelsCommentModel.user_id?.id ?? '',
                                );
                              },
                            ),
                          )),
                        );
                      },

                      // ── Profile Eye ──
                      onPressedReelsEye: () {
                        ProfileNavigator.navigateToProfile(
                          username: reel.reel_user?.username ?? '',
                          isFromPageReels: 'true',
                          isFromReels: 'true',
                        );
                      },

                      // ── Edit Reel ──
                      onTapEditReel: () {
                        Get.toNamed(Routes.EDIT_REELS, arguments: {
                          'reel_id': reel.key,
                          'description': reel.description,
                          'privacy': reel.reels_privacy,
                          'skipLength':
                              widget.controller.reelsModelList.value.length
                        });
                      },
                    );
                  });
                },
              ),

              // ─── Back Button ─────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 12,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // ─── "Suggested Reels" label + Reels link ─────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 14,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Suggested Reels',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.REELS);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Reels',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Build the end card shown after all suggested reels
  Widget _buildEndCard(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.movie_filter_outlined,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Suggested Reels Complete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Continue to discover more amazing reels',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Countdown
              Obx(() => Text(
                'Continuing in ${widget.controller.autoForwardCountdown.value}s...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              )),
              const SizedBox(height: 20),

              // Continue Button
              GestureDetector(
                onTap: () => widget.controller.continueToReels(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF405DE6), Color(0xFFC13584)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue to Reels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Go Back option
              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
