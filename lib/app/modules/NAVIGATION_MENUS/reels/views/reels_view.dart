import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../components/reels_component.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../../../utils/loader.dart';
import '../../user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../components/reels_campaign_comment_component.dart';
import '../components/reels_campaign_component.dart';
import '../components/reels_comment_component.dart';
import '../controllers/reels_controller.dart';
import '../model/reels_campaign_model.dart';
import '../model/reels_model.dart';
import '../model/reels_reacted_user_model.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();

    // Data fetching is now handled in ReelsController.onInit() to avoid
    // "setState() called during build" errors from mutating reactive state.

    return ReelsViewBody(
      controller: controller,
      carouselController: carouselController,
    );
  }
}

// Separate StatefulWidget to manage loader lifecycle
class ReelsViewBody extends StatefulWidget {
  final ReelsController controller;
  final CarouselController carouselController;

  const ReelsViewBody({
    Key? key,
    required this.controller,
    required this.carouselController,
  }) : super(key: key);

  @override
  State<ReelsViewBody> createState() => _ReelsViewBodyState();
}

class _ReelsViewBodyState extends State<ReelsViewBody>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  Worker? _loadingWorker;
  bool _isLoaderShown = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to loading state changes and manage loader
    _loadingWorker = ever(widget.controller.isLoading, (bool loading) {
      // Only show/hide loader if this widget is mounted (visible)
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
    WidgetsBinding.instance.removeObserver(this);
    // Clean up: dismiss loader and dispose worker
    _loadingWorker?.dispose();
    if (_isLoaderShown) {
      dismissLoader();
      _isLoaderShown = false;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.controller.pauseAllReels();
    } else if (state == AppLifecycleState.resumed) {
      widget.controller.resumeReels();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Obx(() {
          final mergedList = _getMergedList(
            widget.controller.reelsModelList.value,
            widget.controller.reelsCampaignResultList.value,
          );

          // If still loading, show empty container (loader is handled by worker)
          if (widget.controller.isLoading.value) {
            return Center(child: Container());
          }

          // If no data, show empty state
          if (mergedList.isEmpty) {
            return Center(
              child: Text(
                'No reels available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: widget.controller.reelsTabPageController,
                scrollDirection: Axis.vertical,
                itemCount: mergedList.length,
                onPageChanged: (int index) {
                  final item = mergedList[index];
                  if (item is ReelsModel) {
                    widget.controller.onReelViewed(item.id ?? '', index);
                  }
                },
                itemBuilder: (context, index) {
                  final item = mergedList[index];

                  if (item is ReelsModel) {
                    return Obx(() {
                      final reelsIndex = widget.controller.reelsModelList.value
                          .indexWhere((reel) => reel.id == item.id);
                      final current = reelsIndex != -1
                          ? widget.controller.reelsModelList.value[reelsIndex]
                          : item;

                      final myId =
                          widget.controller.loginCredential.getUserData().id;
                      final bool isLiked = (current.reactions ?? []).any((r) {
                        try {
                          return (r.reacted_user?.id == myId) ||
                              (r.user_id?.id == myId);
                        } catch (_) {
                          return false;
                        }
                      });

                      return ReelsComponent(
                        key: ValueKey(item.id),
                        externalController: widget.controller
                            .getPreloadedController(item.id ?? ''),
                        //==========================On Tap Delete =========================//
                        onTapDelete: () async {
                          showDeleteAlertDialogs(
                            context: context,
                            deletingItemType: 'Reel',
                            onDelete: () {
                              widget.controller
                                  .deleteReels(item.id ?? '', item.key ?? '');
                            },
                            onCancel: () {
                              Get.back();
                            },
                          );
                        },

                        //==========================On Tap Report =========================//
                        onPressedReport: () async {
                          await widget.controller.getReports();
                          CustomReportBottomSheet.showReportOptions(
                            context: context,
                            pageReportList:
                                widget.controller.pageReportList.value,
                            selectedReportType:
                                widget.controller.selectedReportType,
                            selectedReportId:
                                widget.controller.selectedReportId,
                            reportDescription:
                                widget.controller.reportDescription,
                            onCancel: () {
                              Get.back();
                            },
                            reportAction: (String report_type_id,
                                String report_type,
                                String page_id,
                                String description) {
                              widget.controller.reportRepository.reportAPost(
                                  id_key: 'post_id',
                                  report_type: report_type,
                                  description: description,
                                  post_id: widget.controller.reelsModelList
                                          .value[index].id ??
                                      '',
                                  report_type_id: report_type_id);
                            },
                          );
                        },

                        loginCredentials: widget.controller.loginCredential,

                        //==========================On Tap View Profile =========================//
                        onPressedViewProfile: () {
                          ProfileNavigator.navigateToProfile(
                              username: item.reel_user?.username ?? '',
                              isFromReels: 'false');
                        },

                        //==========================On Tap Share Reels =========================//
                        onPressedShareReels: () {
                          showDraggableScrollableBottomSheet(context,
                              child: ShareSheetWidget(
                                userId: item.reel_user?.id ?? '',
                                reelsId: item.id ?? '',
                                report_id_key: 'reel_id',
                              ));
                        },

                        //==========================On Tap View React =========================//
                        onPressedViewReact: () {
                          Get.toNamed(Routes.REELS_REACTIONS,
                              arguments: item.id);
                        },

                        isLiked: isLiked,
                        carouselController: widget.carouselController,
                        reelsModel: current,

                        //==========================On Tap Like =========================//
                        onPressedLike: () {
                          final reelsIndex = widget
                              .controller.reelsModelList.value
                              .indexWhere((reel) => reel.id == item.id);
                          if (reelsIndex == -1) return;

                          final current = widget
                              .controller.reelsModelList.value[reelsIndex];
                          final myId = widget.controller.loginCredential
                              .getUserData()
                              .id;

                          // detect existing like (best-effort)
                          final bool alreadyLiked =
                              (current.reactions ?? []).any((r) {
                            try {
                              return (r.reacted_user?.id == myId) ||
                                  (r.user_id?.id == myId);
                            } catch (_) {
                              return false;
                            }
                          });

                          // new count
                          final int updatedCount =
                              (current.reaction_count ?? 0) +
                                  (alreadyLiked ? -1 : 1);

                          // build optimistic reactions list
                          List<ReelsReactionModel> newReactions =
                              List<ReelsReactionModel>.from(
                                  current.reactions ?? []);

                          if (!alreadyLiked) {
                            // add a minimal optimistic reaction so UI shows "liked"
                            newReactions.insert(
                              0,
                              ReelsReactionModel(
                                reacted_user: ReelsReactedUserIdModel(id: myId),
                                reaction_type: 'like',
                              ),
                            );
                          } else {
                            // remove reactions by this user
                            newReactions = newReactions.where((r) {
                              try {
                                return !(r.reacted_user?.id == myId ||
                                    r.user_id?.id == myId);
                              } catch (_) {
                                return true;
                              }
                            }).toList();
                          }

                          // create optimistic model
                          final updatedModel = current.copyWith(
                            reaction_count: updatedCount,
                            reactions: newReactions,
                          );

                          // apply optimistic update to the Rx<List> (make a new list then assign)
                          final updatedList = List<ReelsModel>.from(
                              widget.controller.reelsModelList.value);
                          updatedList[reelsIndex] = updatedModel;
                          widget.controller.reelsModelList.value = updatedList;

                          // fire-and-forget the backend call
                          widget.controller
                              .reelsLike(item.id ?? '', reelsIndex);
                        },

                        //==========================On Tap Reaction =========================//
                        onPressedReaction: (String reactionType) {
                          final reelsIndex = widget
                              .controller.reelsModelList.value
                              .indexWhere((reel) => reel.id == item.id);
                          if (reelsIndex == -1) return;

                          final current = widget
                              .controller.reelsModelList.value[reelsIndex];
                          final myId = widget.controller.loginCredential
                              .getUserData()
                              .id;

                          // Optimistic: toggle reaction
                          final bool alreadyReacted =
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
                                  (alreadyReacted ? -1 : 1);

                          List<ReelsReactionModel> newReactions =
                              List<ReelsReactionModel>.from(
                                  current.reactions ?? []);

                          if (!alreadyReacted) {
                            newReactions.insert(
                              0,
                              ReelsReactionModel(
                                reacted_user: ReelsReactedUserIdModel(id: myId),
                                reaction_type: reactionType,
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

                          // Fire API call
                          widget.controller.reelsReaction(
                              item.id ?? '', reelsIndex, reactionType);
                        },

                        //==========================On Tap Comment =========================//
                        onPressedComment: () {
                          widget.controller.getReelCommentList(item.id ?? '');

                          Get.bottomSheet(Obx(() => ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                child: ReelsCommentComponent(
                                  reelsCommentList: widget
                                      .controller.reelsCommentModelList.value,
                                  reelsModel: item,
                                  onTapViewReactions: () {
                                    Get.toNamed(Routes.REELS_REACTIONS,
                                        arguments: item.id);
                                  },
                                  onTapSendReelsComment: () {
                                    widget.controller.reelsComments(
                                        item.id ?? '',
                                        widget.controller.reelsCommentController
                                            .text,
                                        index,
                                        item.key ?? '');
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
                                        post_id: item.id ?? '',
                                        replies_user_id: widget
                                                .controller.loginCredential
                                                .getUserData()
                                                .id ??
                                            '',
                                        file: file, key: item.key ?? '');
                                  },
                                  onSelectReelsCommentReplayReaction:
                                      (String reaction,
                                          String commentId,
                                          String commentRepliesId,
                                          String userId) {
                                    widget.controller.reelsReplyCommentReaction(
                                        reactionType: reaction,
                                        post_id: item.id ?? '',
                                        comment_id: commentId,
                                        comment_reply_id: commentRepliesId,
                                        userId: userId);
                                  },
                                  onReelsCommentEdit:
                                      (reelsCommentModel) async {
                                    await Get.toNamed(Routes.EDIT_REELS_COMMENT,
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
                                        });
                                    widget.controller.getReelCommentList(
                                        reelsCommentModel.post_id ?? '');
                                  },
                                  onReelsCommentDelete: (reelsCommentModel) {
                                    widget.controller.reelsCommentDelete(
                                        reelsCommentModel.id ?? '',
                                        reelsCommentModel.post_id ?? '',
                                        index,
                                        reelsCommentModel.key ?? '');
                                  },
                                  onReelsCommentReplayEdit:
                                      (reelsCommenReplytModel) async {
                                    await Get.toNamed(
                                        Routes.EDIT_REELS_REPLY_COMMENT,
                                        arguments: {
                                          'reply_comment':
                                              reelsCommenReplytModel
                                                  .replies_comment_name,
                                          'replay_post_id':
                                              reelsCommenReplytModel.post_id,
                                          'comment_replay_id':
                                              reelsCommenReplytModel.id,
                                          'comment_type': reelsCommenReplytModel
                                              .comment_type,
                                          'image_video': reelsCommenReplytModel
                                              .image_or_video,
                                          'key': reelsCommenReplytModel.key,
                                        });
                                    widget.controller.getReelCommentList(
                                        reelsCommenReplytModel.post_id ?? '');
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
                                        post_id: item.id ?? '',
                                        comment_id: reelsCommentModel.id ?? '',
                                        userId: reelsCommentModel.user_id?.id ??
                                            '');
                                  },
                                ),
                              )));
                        },

                        onPressedReelsEye: () {
                          Get.toNamed(
                            Routes.USER_REELS,
                            arguments: {
                              'userId': item.reel_user?.id ?? '',
                              'username': item.reel_user?.username ?? '',
                              'userFullName': '${item.reel_user?.first_name ?? ''} ${item.reel_user?.last_name ?? ''}'.trim(),
                              'userProfilePic': item.reel_user?.profile_pic ?? '',
                            },
                          );
                        },

                        onTapEditReel: () {
                          Get.toNamed(Routes.EDIT_REELS, arguments: {
                            'reel_id': item.key,
                            'description': item.description,
                            'privacy': item.reels_privacy,
                            'skipLength':
                                widget.controller.reelsModelList.value.length
                          });
                        },
                      );
                    });
                  }
                  return null;
                },
              ),
              if (widget.controller.isLoadingMore.value)
                const SizedBox(
                  height: 50,
                ),
              // Feed Tab Bar (For You / Following / Trending)
              if (widget.controller.specificReels.value.isEmpty)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 0,
                  right: 0,
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeedTab('For You', 0,
                              widget.controller.activeFeedTab.value),
                          const SizedBox(width: 16),
                          _buildFeedTab('Following', 1,
                              widget.controller.activeFeedTab.value),
                          const SizedBox(width: 16),
                          _buildFeedTab('Trending', 2,
                              widget.controller.activeFeedTab.value),
                        ],
                      )),
                ),
              // Bottom Loading Indicator
              Obx(() {
                // Show loading indicator when fetching more reels
                if (widget.controller.isLoadingMore.value) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 50,
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFeedTab(String label, int tabIndex, int activeTab) {
    final bool isActive = activeTab == tabIndex;
    return GestureDetector(
      onTap: () => widget.controller.switchFeedTab(tabIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              shadows: const [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.5,
            width: isActive ? 24 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getMergedList(
      List<ReelsModel> reels, List<ReelsCampaignResults> campaigns,
      {String? initialId}) {
    final List<dynamic> merged = [];
    final seenReelIds = <String>{};
    if (initialId != null && initialId.isNotEmpty) {
      final idx = reels.indexWhere((r) => r.id == initialId);
      if (idx != -1) {
        merged.add(reels[idx]);
        seenReelIds.add(initialId);
      }
    }

    for (var r in reels) {
      if (r.id == null) continue;
      if (seenReelIds.contains(r.id)) continue;
      merged.add(r);
      seenReelIds.add(r.id!);
    }
    final List<dynamic> finalMerged = [];
    int reelCount = 0;
    int campaignIndex = 0;

    for (var item in merged) {
      finalMerged.add(item);
      if (item is ReelsModel) {
        reelCount++;
        if (reelCount % 5 == 0 && campaigns.isNotEmpty) {
          finalMerged.add(campaigns[campaignIndex]);
          campaignIndex = (campaignIndex + 1) % campaigns.length;
        }
      }
    }
    return finalMerged;
  }
}
