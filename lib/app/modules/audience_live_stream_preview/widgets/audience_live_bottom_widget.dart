import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/reaction_button/post_reaction_button.dart';
import '../../../models/post.dart';

class AudienceLiveBottomWidget extends StatelessWidget {
  /// tapping on message button
  final void Function() onMessaegeTap;

  /// text editing controller
  final TextEditingController textEditingController;

  /// field focus node
  final FocusNode focusNode;

  /// tapping on share button
  final void Function() onShareTap;

  /// on field submitted
  final void Function(String)? onFieldSubmitted;

  final VoidCallback onSendComment;

  /// share count
  final String? shareCount;

  final PostModel? postModel;

  final Function(String reaction) onSelectReaction;

    AudienceLiveBottomWidget(
      {super.key,
      this.postModel,
      required this.onMessaegeTap,
      required this.onSendComment,
      required this.textEditingController,
      required this.focusNode,
      required this.onShareTap,
      this.onFieldSubmitted,
      required this.onSelectReaction,
      this.shareCount});

  @override
  Widget build(BuildContext context) {
    bool messageSend = false;

    return Padding(
      padding:
            EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ============================= left section ==========================
          IconButton(
              onPressed: onMessaegeTap,
              icon:   Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined, color: Colors.white, size: 24),
                  SizedBox(height: 2),
                  Text('Message'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )),

            SizedBox(width: 8),
          // ============================= Middle section ========================
          Expanded(
              child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Get.bottomSheet(Container(
                width: Get.width,
                padding:   EdgeInsetsDirectional.symmetric(
                    vertical: 10, horizontal: 15),
                decoration:   BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (value) {
                          if (!messageSend) {
                            messageSend = true;
                            onFieldSubmitted!(value);
                            Get.back();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Type Comment'.tr,
                            hintStyle: TextStyle(
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                            contentPadding:
                                  EdgeInsetsDirectional.symmetric(
                                    vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black.withValues(alpha: 0.4)),
                                borderRadius: BorderRadius.circular(24)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black.withValues(alpha: 0.4)),
                                borderRadius: BorderRadius.circular(24)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                      BorderSide(color: Colors.teal),
                                borderRadius: BorderRadius.circular(24))),
                      ),
                    ),
                      SizedBox(height: 8),
                    IconButton(
                      onPressed: () {
                        if (!messageSend) {
                          messageSend = true;
                          onSendComment();
                          Get.back();
                        }
                      },
                      icon:   Icon(
                        Icons.send,
                        size: 25,
                      ),
                    )
                  ],
                ),
              )).then((e) {
                focusNode.unfocus();
                messageSend = false;
              });

              Future.delayed(  Duration(milliseconds: 100), () {
                focusNode.requestFocus();
              });
            },
            child: Container(
              width: Get.width,
              padding:   EdgeInsetsDirectional.symmetric(
                  vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type Comment'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(Icons.emoji_emotions_outlined,
                      color: Colors.white, size: 20)
                ],
              ),
            ),
          )),
            SizedBox(width: 8),
// ============================= reaction section =======================
          PostReactionButton(
              onChangedReaction: (reaction) {
                onSelectReaction(reaction.value);
              },
              isShowLikeText: false),
            SizedBox(width: 8),
          // ============================= right section ==========================
          IconButton(
              onPressed: onMessaegeTap,
              icon: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon/share.png',
                      color: Colors.white, height: 24, width: 24),
                    SizedBox(height: 2),
                  Text(
                    shareCount ?? '0',
                    textAlign: TextAlign.center,
                    style:   TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
