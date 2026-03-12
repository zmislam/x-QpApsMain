// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:share_plus/share_plus.dart';

import '../config/constants/app_assets.dart';
import '../models/post.dart';
import '../routes/app_pages.dart';
import '../utils/post_utlis.dart';

class MyDayDetail extends StatefulWidget {
  final String imageURL;
  final String profileImage;
  final String userName;
  final String createdAt;
  final String title;
  final String id;
  final bool isProfile;
  final String viewCont;

  const MyDayDetail({
    super.key,
    required this.imageURL,
    required this.profileImage,
    required this.userName,
    required this.createdAt,
    required this.title,
    required this.id,
    required this.isProfile,
    required this.viewCont,
  });

  @override
  State<MyDayDetail> createState() => _MyDayDetailState();
}

class _MyDayDetailState extends State<MyDayDetail>
    with TickerProviderStateMixin {
  RxBool isTap = false.obs;

  late AnimationController animationController;
  List<Icon> iconList = [
    const Icon(
      Icons.thumb_up,
      color: Colors.blue,
    ),
    const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
    const Icon(
      Icons.emoji_emotions_rounded,
      color: Colors.amber,
    ),
    const Icon(
      Icons.sentiment_satisfied,
      color: Colors.green,
    ),
    const Icon(
      Icons.sentiment_dissatisfied,
      color: Colors.red,
    ),
  ];

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            if (animationController.value >= 0.99) {
              animationController.stop();
              // Get.back();
            }

            setState(() {});
          });

    animationController.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    debugPrint('view count .................${widget.viewCont}');

    return Scaffold(
      body: InkWell(
        onTapDown: (tapDetail) {
          //if(isTap.value==false){
          animationController.stop();
          isTap.value = true;
          //}
          // else{
          //   animationController.repeat();
          //   isTap.value=false;
          // }
        },
        onTapUp: (tapDetail) {
          animationController.repeat();
          isTap.value = false;
        },
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                widget.imageURL,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  LinearProgressIndicator(
                    color: PRIMARY_COLOR,
                    value: animationController.value,
                    // semanticsLabel: 'Linear progress indicator',
                  ),
                  Container(
                      width: Get.width,
                      color: Colors.grey.withValues(alpha: 0.3),
                      //margin: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 19,
                                backgroundColor:
                                    const Color.fromARGB(255, 45, 185, 185),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundImage:
                                      NetworkImage(widget.profileImage),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width / 3 - 10,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          widget.userName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: Get.width / 3 - 10,
                                    //   child: Text(
                                    //     ' ${widget.createdAt}',
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: const TextStyle(
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.white),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PopupMenuButton(
                                      color: Colors.transparent,
                                      offset: const Offset(10, 60),
                                      iconColor: Colors.white,
                                      icon: const Icon(Icons.more_horiz),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () {
                                                homeController
                                                    .deleteStory(widget.id);
                                                // homeController.getStories();
                                              },
                                              value: 1,
                                              // row has two child icon and text.
                                              child: Text('Delete'.tr,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            // const PopupMenuItem(
                                            //   value: 1,
                                            //   // row has two child icon and text.
                                            //   child: Text(
                                            //     'Report',
                                            //     style: TextStyle(color: Colors.white),
                                            //   ),
                                            // ),
                                          ]),
                                  // IconButton(
                                  //     onPressed: () {
                                  //
                                  //
                                  //     },
                                  //     icon: const Icon(
                                  //       Icons.more_horiz,
                                  //       color: Colors.white,
                                  //     )),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 45.0),
                              child: Text(' ${widget.createdAt}'.tr,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )

                      // ListTile(
                      //   leading:
                      //   CircleAvatar(
                      //     radius: 19,
                      //     backgroundColor: const Color.fromARGB(255, 45, 185, 185),
                      //     child: CircleAvatar(
                      //       radius: 17,
                      //       backgroundImage: NetworkImage(widget.profileImage),
                      //     ),
                      //   ),
                      //   title: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           SizedBox(
                      //             width: Get.width / 3 - 10,
                      //             child: Text(
                      //               widget.userName,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: const TextStyle(
                      //                 fontWeight: FontWeight.bold, fontSize: 16),
                      //             ),
                      //           ),
                      //           // SizedBox(
                      //           //   width: Get.width / 3 - 10,
                      //           //   child: Text(
                      //           //     ' ${widget.createdAt}',
                      //           //     overflow: TextOverflow.ellipsis,
                      //           //     style: const TextStyle(
                      //           //         fontSize: 16,
                      //           //         fontWeight: FontWeight.bold,
                      //           //         color: Colors.white),
                      //           //   ),
                      //           // ),
                      //         ],
                      //       ),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           PopupMenuButton(
                      //               color: Colors.transparent,
                      //               offset: const Offset(10, 60),
                      //               iconColor: Colors.white,
                      //               icon: const Icon(Icons.more_horiz),
                      //               itemBuilder: (context) => [
                      //                     PopupMenuItem(
                      //                       onTap: () {
                      //                         homeController
                      //                             .deleteStory(widget.id);
                      //                         homeController.getStories();
                      //                       },
                      //                       value: 1,
                      //                       // row has two child icon and text.
                      //                       child: const Text(
                      //                         'Delete',
                      //                         style:
                      //                             TextStyle(color: Colors.white),
                      //                       ),
                      //                     ),
                      //                     // const PopupMenuItem(
                      //                     //   value: 1,
                      //                     //   // row has two child icon and text.
                      //                     //   child: Text(
                      //                     //     'Report',
                      //                     //     style: TextStyle(color: Colors.white),
                      //                     //   ),
                      //                     // ),
                      //                   ]),
                      //           // IconButton(
                      //           //     onPressed: () {
                      //           //
                      //           //
                      //           //     },
                      //           //     icon: const Icon(
                      //           //       Icons.more_horiz,
                      //           //       color: Colors.white,
                      //           //     )),
                      //           IconButton(
                      //               onPressed: () {
                      //                 Get.back();
                      //               },
                      //               icon: const Icon(
                      //                 Icons.close,
                      //                 color: Colors.white,
                      //               )),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      //   subtitle: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       SizedBox(
                      //         width: Get.width / 3 - 10,
                      //         child: Text(
                      //           ' ${widget.createdAt}',
                      //           overflow: TextOverflow.ellipsis,
                      //           style: const TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.white),
                      //         ),
                      //       ),
                      //       // Text(
                      //       //   widget.title,
                      //       //   style: const TextStyle(
                      //       //       fontSize: 12,
                      //       //       fontWeight: FontWeight.bold,
                      //       //       color: Colors.white),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                      ),
                ],
              ),
              widget.isProfile != true
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Share.share(widget.imageURL,
                                //'Reels: ${ApiConstant.SERVER_IP}/reels/${reelsModel.id ?? ''}    ',
                                subject: 'Look at this');
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            // padding: EdgeInsets.all(10),
                            // alignment: Alignment.center,
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.share),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: Get.width - 170,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                  alpha:
                                      0.5), //Color.fromARGB(135, 238, 238, 238),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            onTap: () {
                              animationController.stop();
                              isTap.value = true;
                            },
                            decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: 'Send message'.tr,
                                hintStyle: TextStyle(fontSize: 15),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // Share.share(
                            //     '${widget.imageURL}',
                            //     //'Reels: ${ApiConstant.SERVER_IP}/reels/${reelsModel.id ?? ''}    ',
                            //     subject: 'Look at this');
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            // padding: EdgeInsets.all(10),
                            // alignment: Alignment.center,
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.send),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              //const SizedBox(width: 10),
                              ReactionButton<String>(
                                itemSize: const Size(32, 32),
                                onReactionChanged:
                                    (Reaction<String>? reaction) {
                                  // homeController.storyReaction(
                                  //     '${LoginCredential().getUserData().id}',
                                  //     widget.id,
                                  //     '$reaction');
                                  //onSelectReaction(reaction?.value ?? '');
                                },
                                placeholder: const Reaction<String>(
                                  value: 'like',
                                  icon: Row(
                                    children: [
                                      Icon(Icons.thumb_up_alt_outlined)

                                      // ReactionIcon(AppAssets.LIKE_ACTION_ICON),
                                      // const SizedBox(width: 10),
                                      // Text('Like'.tr,
                                      //     style: TextStyle(
                                      //       fontSize: 18,
                                      //       color: Colors.grey.shade700,
                                      //     ))
                                    ],
                                  ),
                                ),
                                // isChecked: getSelectedReaction(model) != null,
                                // selectedReaction: getSelectedReaction(model),
                                reactions: <Reaction<String>>[
                                  Reaction<String>(
                                    value: 'like',
                                    icon: ReactionIcon(AppAssets.LIKE_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'love',
                                    icon: ReactionIcon(AppAssets.LOVE_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'haha',
                                    icon: ReactionIcon(AppAssets.HAHA_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'wow',
                                    icon: ReactionIcon(AppAssets.WOW_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'sad',
                                    icon: ReactionIcon(AppAssets.SAD_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'angry',
                                    icon: ReactionIcon(AppAssets.ANGRY_ICON),
                                  ),
                                  Reaction<String>(
                                    value: 'dislike',
                                    icon: ReactionIcon(AppAssets.UNLIKE_ICON),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        Get.toNamed(Routes.STORY_REACTION,
                            arguments: widget.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: Text('${widget.viewCont} People viewed your story'.tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Reaction<String>? getSelectedReaction(PostModel postModel) {
    ReactionModel? reactionModel =
        postModel.reactionTypeCountsByPost?.firstWhere(
      (element) => element.user_id == '6514147376594264b1103efe',
      orElse: () => ReactionModel(count: -1),
    );
    if (reactionModel != null) {
      if (reactionModel.count != -1) {
        return getReactionAsReactionType(reactionModel.reaction_type ?? '');
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

Reaction<String> getReactionAsReactionType(String type) {
  if (type == 'like') {
    return Reaction<String>(
      value: 'like',
      icon: ReactionIcon(AppAssets.LIKE_ICON),
    );
  } else if (type == 'love') {
    return Reaction<String>(
      value: 'love',
      icon: ReactionIcon(AppAssets.LOVE_ICON),
    );
  } else if (type == 'haha') {
    return Reaction<String>(
      value: 'haha',
      icon: ReactionIcon(AppAssets.HAHA_ICON),
    );
  } else if (type == 'wow') {
    return Reaction<String>(
      value: 'wow',
      icon: ReactionIcon(AppAssets.WOW_ICON),
    );
  } else if (type == 'sad') {
    return Reaction<String>(
      value: 'sad',
      icon: ReactionIcon(AppAssets.SAD_ICON),
    );
  } else if (type == 'angry') {
    return Reaction<String>(
      value: 'angry',
      icon: ReactionIcon(AppAssets.ANGRY_ICON),
    );
  } else if (type == 'dislike') {
    return Reaction<String>(
      value: 'dislike',
      icon: ReactionIcon(AppAssets.UNLIKE_ICON),
    );
  } else {
    return Reaction<String>(
      value: 'like',
      icon: ReactionIcon(AppAssets.LIKE_ICON),
    );
  }
}
