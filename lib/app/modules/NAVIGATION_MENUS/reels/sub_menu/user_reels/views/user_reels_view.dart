import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../../components/reels_component.dart';
import '../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../../../../../../utils/bottom_sheet.dart';
import '../../../../../../utils/loader.dart';
import '../../../../user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../components/reels_comment_component.dart';
import '../../../model/reels_model.dart';
import '../../../model/reels_reacted_user_model.dart';
import '../controllers/user_reels_controller.dart';

class UserReelsView extends GetView<UserReelsController> {
  const UserReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isViewerMode.value) {
        return _UserReelsViewerPage(controller: controller);
      }
      return _UserReelsListPage(controller: controller);
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// List Page - Shows all reels from the user in a scrollable list
// ─────────────────────────────────────────────────────────────────────────────

class _UserReelsListPage extends StatelessWidget {
  final UserReelsController controller;
  const _UserReelsListPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              controller.userFullName.isNotEmpty 
                  ? controller.userFullName 
                  : controller.username,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Reels',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
          );
        }

        final reels = controller.reelsModelList.value;

        if (reels.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.movie_outlined, color: Colors.grey.shade300, size: 56),
                const SizedBox(height: 12),
                Text(
                  'No reels yet',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This user hasn\'t posted any reels',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 200) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: reels.length + (controller.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              if (index >= reels.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 2),
                  ),
                );
              }
              return _buildReelItem(context, reels[index], index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildReelItem(BuildContext context, ReelsModel reel, int index) {
    // Build thumbnail URL
    String thumbnailUrl = '';
    if (reel.image != null && reel.image!.isNotEmpty) {
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/${reel.image!.first}';
    } else if (reel.video_thumbnail != null && reel.video_thumbnail!.isNotEmpty) {
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/${reel.video_thumbnail}';
    } else if (reel.video != null && reel.video!.isNotEmpty) {
      final videoName = reel.video!;
      final dotIndex = videoName.lastIndexOf('.');
      final baseName = dotIndex > 0 ? videoName.substring(0, dotIndex) : videoName;
      thumbnailUrl = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/$baseName-thumbnail.png';
    }

    final description = reel.description ?? '';
    final viewCount = reel.view_count ?? 0;

    return InkWell(
      onTap: () => controller.enterViewerMode(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 140,
                    height: 90,
                    child: thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: Colors.grey[200]),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.play_circle_outline,
                                  color: Colors.grey, size: 32),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.play_circle_outline,
                                color: Colors.grey, size: 32),
                          ),
                  ),
                ),
                // Play icon overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    )
                  else
                    Text(
                      'Reel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '$viewCount views',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // 3-dot menu
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 22),
              onPressed: () => _showReelOptions(context, reel),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void _showReelOptions(BuildContext context, ReelsModel reel) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.black87),
                title: const Text('Share', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                onTap: () {
                  Get.back();
                  showDraggableScrollableBottomSheet(
                    context,
                    child: ShareSheetWidget(
                      userId: reel.reel_user?.id ?? '',
                      reelsId: reel.id ?? '',
                      report_id_key: 'reel_id',
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Viewer Page - Full-screen swipeable reel viewer
// ─────────────────────────────────────────────────────────────────────────────

class _UserReelsViewerPage extends StatefulWidget {
  final UserReelsController controller;
  const _UserReelsViewerPage({required this.controller});

  @override
  State<_UserReelsViewerPage> createState() => _UserReelsViewerPageState();
}

class _UserReelsViewerPageState extends State<_UserReelsViewerPage> {
  Worker? _loadingWorker;
  bool _isLoaderShown = false;
  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.controller.exitViewerMode();
        }
      },
      child: SafeArea(
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
                      final myId = widget.controller.loginCredential.getUserData().id;
                      final bool isLiked = (reel.reactions ?? []).any((r) {
                        try {
                          return (r.reacted_user?.id == myId) || (r.user_id?.id == myId);
                        } catch (_) {
                          return false;
                        }
                      });

                      return ReelsComponent(
                        carouselController: _carouselController,
                        isLiked: isLiked,
                        reelsModel: reel,
                        loginCredentials: widget.controller.loginCredential,

                        // ── Delete ──
                        onTapDelete: () async {
                          showDeleteAlertDialogs(
                            context: context,
                            deletingItemType: 'Reel',
                            onDelete: () {
                              widget.controller.deleteReels(reel.id ?? '', reel.key ?? '');
                            },
                            onCancel: () => Get.back(),
                          );
                        },

                        // ── Report ──
                        onPressedReport: () async {
                          await widget.controller.getReports();
                          if (!context.mounted) return;
                          CustomReportBottomSheet.showReportOptions(
                            context: context,
                            pageReportList: widget.controller.pageReportList.value,
                            selectedReportType: widget.controller.selectedReportType,
                            selectedReportId: widget.controller.selectedReportId,
                            reportDescription: widget.controller.reportDescription,
                            onCancel: () => Get.back(),
                            reportAction: (String reportTypeId, String reportType,
                                String pageId, String description) {
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
                          Get.toNamed(Routes.REELS_REACTIONS, arguments: reel.id);
                        },

                        // ── Like ──
                        onPressedLike: () {
                          final reelsIndex = index;
                          final current = widget.controller.reelsModelList.value[reelsIndex];
                          final updatedCount = (current.reaction_count ?? 0) + (isLiked ? -1 : 1);
                          List<ReelsReactionModel> newReactions = List.from(current.reactions ?? []);
                          if (!isLiked) {
                            newReactions.add(ReelsReactionModel(
                              reacted_user: ReelsReactedUserIdModel(id: myId),
                              reaction_type: 'like',
                            ));
                          } else {
                            newReactions = newReactions.where((r) {
                              try {
                                return !(r.reacted_user?.id == myId || r.user_id?.id == myId);
                              } catch (_) {
                                return true;
                              }
                            }).toList();
                          }

                          final updatedModel = current.copyWith(
                            reaction_count: updatedCount,
                            reactions: newReactions,
                          );

                          final updatedList = List<ReelsModel>.from(widget.controller.reelsModelList.value);
                          updatedList[reelsIndex] = updatedModel;
                          widget.controller.reelsModelList.value = updatedList;

                          widget.controller.reelsLike(reel.id ?? '', reelsIndex);
                        },

                        // ── Reaction ──
                        onPressedReaction: (String reactionType) {
                          final reelsIndex = index;
                          final current = widget.controller.reelsModelList.value[reelsIndex];
                          final updatedCount = (current.reaction_count ?? 0) + (isLiked ? -1 : 1);
                          List<ReelsReactionModel> newReactions = List.from(current.reactions ?? []);
                          if (!isLiked) {
                            newReactions.add(ReelsReactionModel(
                              reacted_user: ReelsReactedUserIdModel(id: myId),
                              reaction_type: reactionType,
                            ));
                          } else {
                            newReactions = newReactions.where((r) {
                              try {
                                return !(r.reacted_user?.id == myId || r.user_id?.id == myId);
                              } catch (_) {
                                return true;
                              }
                            }).toList();
                          }

                          final updatedModel = current.copyWith(
                            reaction_count: updatedCount,
                            reactions: newReactions,
                          );

                          final updatedList = List<ReelsModel>.from(widget.controller.reelsModelList.value);
                          updatedList[reelsIndex] = updatedModel;
                          widget.controller.reelsModelList.value = updatedList;

                          widget.controller.reelsReaction(reel.id ?? '', reelsIndex, reactionType);
                        },

                        // ── Comment ──
                        onPressedComment: () {
                          widget.controller.getReelCommentList(reel.id ?? '');

                          Get.bottomSheet(
                            Obx(() => ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: ReelsCommentComponent(
                                reelsCommentList: widget.controller.reelsCommentModelList.value,
                                reelsModel: reel,
                                onTapViewReactions: () {
                                  Get.toNamed(Routes.REELS_REACTIONS, arguments: reel.id);
                                },
                                onTapSendReelsComment: () {
                                  widget.controller.reelsComments(
                                    reel.id ?? '',
                                    widget.controller.reelsCommentController.text,
                                    index,
                                    reel.key ?? '',
                                  );
                                  widget.controller.reelsCommentController.clear();
                                },
                                reelsCommentController: widget.controller.reelsCommentController,
                                userModel: widget.controller.loginCredential.getUserData(),
                                onTapReelsReplayComment: ({
                                  required commentReplay,
                                  required comment_id,
                                  required file,
                                }) {
                                  widget.controller.reelsCommentsReply(
                                    comment_id: comment_id,
                                    replies_comment_name: commentReplay,
                                    post_id: reel.id ?? '',
                                    replies_user_id: widget.controller.loginCredential.getUserData().id ?? '',
                                    file: file,
                                    key: reel.key ?? '',
                                  );
                                },
                                onSelectReelsCommentReplayReaction:
                                    (String reaction, String commentId, String commentRepliesId, String userId) {
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
                                      'post_comment': reelsCommentModel.comment_name,
                                      'post_id': reelsCommentModel.post_id,
                                      'comment_id': reelsCommentModel.id,
                                      'comment_type': reelsCommentModel.comment_type,
                                      'image_video': reelsCommentModel.image_or_video,
                                      'key': reelsCommentModel.key,
                                    },
                                  );
                                  widget.controller.getReelCommentList(reelsCommentModel.post_id ?? '');
                                },
                                onReelsCommentDelete: (reelsCommentModel) {
                                  widget.controller.reelsCommentDelete(
                                    reelsCommentModel.id ?? '',
                                    reelsCommentModel.post_id ?? '',
                                    index,
                                    reelsCommentModel.key ?? '',
                                  );
                                },
                                onReelsCommentReplayEdit: (reelsCommentReplyModel) async {
                                  await Get.toNamed(
                                    Routes.EDIT_REELS_REPLY_COMMENT,
                                    arguments: {
                                      'reply_comment': reelsCommentReplyModel.replies_comment_name,
                                      'replay_post_id': reelsCommentReplyModel.post_id,
                                      'comment_replay_id': reelsCommentReplyModel.id,
                                      'comment_type': reelsCommentReplyModel.comment_type,
                                      'image_video': reelsCommentReplyModel.image_or_video,
                                      'key': reelsCommentReplyModel.key,
                                    },
                                  );
                                  widget.controller.getReelCommentList(reelsCommentReplyModel.post_id ?? '');
                                },
                                onReelsCommentReplayDelete: (String replyId, String postId, String key) {
                                  widget.controller.reelsCommentReplyDelete(replyId, postId, index.toString(), key);
                                },
                                onSelectReelsCommentReaction: (reaction, reelsCommentModel) {
                                  widget.controller.reelsCommentReaction(
                                    reactionType: reaction,
                                    post_id: reel.id ?? '',
                                    comment_id: reelsCommentModel.id ?? '',
                                    userId: reelsCommentModel.user_id?.id ?? '',
                                  );
                                },
                              ),
                            )),
                          );
                        },

                        // ── Profile Eye ──
                        onPressedReelsEye: () {
                          // Already viewing this user's reels, no action needed
                        },

                        // ── Edit Reel ──
                        onTapEditReel: () {
                          Get.toNamed(Routes.EDIT_REELS, arguments: {
                            'reel_id': reel.key,
                            'description': reel.description,
                            'privacy': reel.reels_privacy,
                            'skipLength': widget.controller.reelsModelList.value.length
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
                    onTap: () => widget.controller.exitViewerMode(),
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

                // ─── User's Reels label ─────────────────────────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top + 14,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.controller.userFullName.isNotEmpty 
                            ? '${widget.controller.userFullName}\'s Reels'
                            : '${widget.controller.username}\'s Reels',
                        style: const TextStyle(
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
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Build the end card shown after all user reels
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
              Text(
                widget.controller.userFullName.isNotEmpty 
                    ? '${widget.controller.userFullName}\'s Reels Complete'
                    : 'User\'s Reels Complete',
                style: const TextStyle(
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
                onTap: () => widget.controller.exitViewerMode(),
                child: Text(
                  'Back to List',
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
