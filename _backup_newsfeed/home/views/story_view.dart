import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import 'package:story/story.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../data/login_creadential.dart';
import '../../../../enum/reaction_type.dart';
import '../../../../extension/num.dart';
import '../../../../models/merge_story.dart';
import '../../../../models/user.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../services/audio_player_service.dart';
import '../../../../utils/post_utlis.dart';

class StoryView extends StatefulWidget {
  const StoryView({
    super.key,
    required this.storyMergeList,
    required this.onTapReaction,
    required this.onTapDeleteStory,
    required this.onStoryViewed,
    required this.onTapSendMessage,
  });
  final Function({required String storyId, required String reactionType})
      onTapReaction;
  final Function({required String storyId, required String comment})
      onTapSendMessage;
  final Function({required String storyId}) onStoryViewed;
  final Function({required String storyId}) onTapDeleteStory;

  final List<StoryMergeModel> storyMergeList;
  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> with TickerProviderStateMixin{
  //Variable Declaration
  late final ValueNotifier<IndicatorAnimationCommand>
      indicatorAnimationController;
  late final LoginCredential credential;
  late final UserModel currentUserModel;
  //Message Send
  late final TextEditingController messageController;
  late final FocusNode messageFocusNode;
  late final AudioPlayerService audioPlayerService;
  String? selectedReaction;
  late AnimationController reactionAnimationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
    credential = LoginCredential();
    currentUserModel = credential.getUserData();
    messageController = TextEditingController();
    messageFocusNode = FocusNode();
    audioPlayerService = AudioPlayerService();
    reactionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(reactionAnimationController);
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    messageController.dispose();
    messageFocusNode.dispose();
    audioPlayerService.stop();
    reactionAnimationController.dispose();
    super.dispose();
  }

  void _handleReactionTap(String reactionType, String storyId) {
    setState(() {
      selectedReaction = reactionType;
    });
    reactionAnimationController.forward(from: 0.0);
    widget.onTapReaction(
      storyId: storyId,
      reactionType: reactionType,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          selectedReaction = null;
        });
      }
    });
  }

  String getReactionCount(StoryReactionModel reactionModel) {
    num count = 0;
    for (var story in widget.storyMergeList) {
      for (var storyItem in story.stories ?? []) {
        count += (storyItem.reactions?.length ?? 0);
      }
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    int initialPage = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: StoryPageView(
        initialPage: initialPage,
        indicatorAnimationController: indicatorAnimationController,
        storyLength: (pageIndex) {
          return widget.storyMergeList[pageIndex].stories?.length ?? 0;
        },
        pageLength: widget.storyMergeList.length,
        onPageLimitReached: () {
          Get.back();
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          StoryMergeModel storyMergeModel = widget.storyMergeList[pageIndex];

          String userName =
              '${storyMergeModel.first_name ?? ''} ${storyMergeModel.last_name ?? ''}';
          String userImage = (storyMergeModel.page_id != null &&
                  storyMergeModel.page_id.toString().isNotEmpty)
              ? (storyMergeModel.profile_pic ?? '').formatedProfileUrl
              : (storyMergeModel.profile_pic ?? '').formatedProfileUrl;
          StoryItemModel? storyItemModel = storyMergeModel.stories?[storyIndex];
          String time = getDynamicFormatedTime(storyItemModel?.createdAt ?? '');
          String musicTile = storyItemModel?.music_info?.titile ?? '';
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ProfileNavigator.navigateToProfile(
                              username: storyMergeModel.username ?? '',
                              isFromReels: 'false');
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  const Color.fromARGB(255, 45, 185, 185),
                              child: CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(userImage),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  musicTile.isNotEmpty
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Icons.music_note,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              musicTile,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : 0.h,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    currentUserModel.username == storyMergeModel.username
                        ? PopupMenuButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) {
                              return [
                                 PopupMenuItem(
                                  value: 1,
                                  // row with 2 children
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Delete'.tr)
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onOpened: () {
                              indicatorAnimationController.value =
                                  IndicatorAnimationCommand.pause;
                            },
                            onCanceled: () {
                              indicatorAnimationController.value =
                                  IndicatorAnimationCommand.resume;
                            },
                            onSelected: (value) {
                              if (value == 1) {
                                widget.onTapDeleteStory(
                                    storyId: storyItemModel?.id ?? '');
                              }
                            },
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              currentUserModel.username == storyMergeModel.username
                  ? InkWell(
                      onTap: () async {
                        indicatorAnimationController.value =
                            IndicatorAnimationCommand.pause;
                        await showViewerList(storyItemModel);
                        indicatorAnimationController.value =
                            IndicatorAnimationCommand.resume;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                indicatorAnimationController.value =
                                    IndicatorAnimationCommand.pause;
                                await showViewerList(storyItemModel);
                                indicatorAnimationController.value =
                                    IndicatorAnimationCommand.resume;
                              },
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                            Text('${storyItemModel?.viewersCount ?? 0} Person View'.tr,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () async {
                                indicatorAnimationController.value =
                                    IndicatorAnimationCommand.pause;
                                messageController.clear();
                                messageFocusNode.requestFocus();
                                await showMessageBottomSheet(storyItemModel);
                                indicatorAnimationController.value =
                                    IndicatorAnimationCommand.resume;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 40,
                                // width: Get.width / 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Reply'.tr)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const SizedBox(width: 10),
                          ReactionIcon(
                            AppAssets.LIKE_ICON,
                            ReactionType.like.name,
                            storyItemModel?.id ?? '',
                          ),
                          ReactionIcon(
                            AppAssets.LOVE_ICON,
                            ReactionType.love.name,
                            storyItemModel?.id ?? '',
                          ),
                          ReactionIcon(
                            AppAssets.HAHA_ICON,
                            ReactionType.haha.name,
                            storyItemModel?.id ?? '',
                          ),
                          ReactionIcon(
                            AppAssets.WOW_ICON,
                            ReactionType.wow.name,
                            storyItemModel?.id ?? '',
                          ),
                          ReactionIcon(
                            AppAssets.SAD_ICON,
                            ReactionType.sad.name,
                            storyItemModel?.id ?? '',
                          ),
                          ReactionIcon(
                            AppAssets.ANGRY_ICON,
                            ReactionType.angry.name,
                            storyItemModel?.id ?? '',
                          ),
                        ],
                      ),
                    )
            ],
          );
        },
        itemBuilder: (context, pageIndex, storyIndex) {
          StoryMergeModel storyMergeModel = widget.storyMergeList[pageIndex];

          StoryItemModel? storyItemModel = storyMergeModel.stories?[storyIndex];

          String storyUrl = (storyItemModel?.media ?? '').formatedStoryUrl;
          widget.onStoryViewed(storyId: storyItemModel?.id ?? '');
          String audioUrl =
              '${ApiConstant.SERVER_IP_PORT}/uploads/audio/${storyItemModel?.music_info?.audio_file ?? ''}';
          audioPlayerService.playUrlSource(audioUrl);
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.grey),
              ),
              Positioned.fill(
                child: StoryImage(
                  key: ValueKey(storyUrl),
                  imageProvider: NetworkImage(
                    storyUrl,
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget ReactionIcon(String assetName, String reactionType, String storyId) {
    final bool isSelected = selectedReaction == reactionType;

    return GestureDetector(
      onTap: () => _handleReactionTap(reactionType, storyId),
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? scaleAnimation.value : 1.0,
            child: child,
          );
        },
        child: Image.asset(
          assetName,
          height: 36,
          width: 36,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future showMessageBottomSheet(StoryItemModel? storyItemModel) async {
    await Get.bottomSheet(Container(
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            focusNode: messageFocusNode,
            decoration: InputDecoration(
                hintText: 'Reply'.tr, border: OutlineInputBorder()),
            controller: messageController,
          )),
          IconButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                widget.onTapSendMessage(
                  storyId: storyItemModel?.id ?? '',
                  comment: messageController.text,
                );
                Get.back();
              }
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    ));
  }

  Future showViewerList(StoryItemModel? storyItemModel) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${storyItemModel?.viewersCount ?? 0} viewers'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: storyItemModel?.viewersList?.length ?? 0,
                      itemBuilder: (context, index) {
                        ViewerModel viewerModel =
                            storyItemModel?.viewersList?[index] ??
                                ViewerModel();
                        List<StoryReactionModel> reactionList =
                            viewerModel.reactions ?? [];
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundImage: NetworkImage(
                                  (viewerModel.profile_pic ?? '')
                                      .formatedProfileUrl),
                            ),
                            const SizedBox(width: 10),
                            Text(
                                '${viewerModel.first_name ?? ''} ${viewerModel.last_name ?? ''}'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:
                                    buildReactionIcons(viewerModel.reactions),
                              ),
                            ),
                            reactionList.isNotEmpty && reactionList.length > 4
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text('+${reactionList.length - 4}'.tr,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }
}

List<Widget> buildReactionIcons(List<StoryReactionModel>? reactions) {
  // Handle null case by treating as empty list
  final validReactions = reactions ?? [];
  final itemCount = validReactions.length > 4 ? 4 : validReactions.length;

  return List<Widget>.generate(itemCount, (index) {
    final reactionType = validReactions[index].reaction_type ?? '';
    return Image(
      height: 24,
      width: 24,
      image: AssetImage(getReactionIconPath(reactionType)),
    );
  });
}
