import 'package:flutter/material.dart';
import '../../extension/string/string_image_path.dart';
import '../../config/constants/color.dart';
import '../../config/constants/app_assets.dart';
import '../../extension/date_time_extension.dart';
import '../../models/help_reply_model.dart';
import 'package:get/get.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.messageModel});

  final HelpReplyModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: messageModel.administrationId == null
            ? Colors.grey.withValues(alpha: 0.2)
            : Colors.white,
        border: messageModel.administrationId == null
            ? Border.all(
                color: Colors.black.withValues(alpha: 0.3),
                // right: BorderSide(
                //   color: PRIMARY_COLOR,
                //   width: 5,
                // ),
              )
            : Border.all(
                color: PRIMARY_COLOR,
                // right: BorderSide(
                //   color: PRIMARY_COLOR,
                //   width: 5,
                // ),
              ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: messageModel.administrationId == null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          messageModel.administrationId == null
              ? Text(
                  (messageModel.userinfo?[0].firstName).toString() +
                      (messageModel.userinfo?[0].lastName).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 17),
                )
              : Text('Quantum Possibilities Authority'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: PRIMARY_COLOR,
                      fontSize: 17),
                ),
          Text(messageModel.description.toString()),
          const SizedBox(
            height: 5,
          ),
          messageModel.photos?.length != 0
              ? attatchmentView(messageModel.photos ?? [])
              : const SizedBox(),
          const SizedBox(
            height: 5,
          ),
          Text(
            (messageModel.createdAt.toString().toDetailFormatDateTime()),
            style: TextStyle(
              color: PRIMARY_COLOR,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget attatchmentView(List<dynamic> attachments) {
    if (attachments.isNotEmpty) {
      return Image(
          errorBuilder: (context, error, stackTrace) => const Image(
                height: 120,
                image: AssetImage(AppAssets.DEFAULT_IMAGE),
              ),
          height: 120,
          image: NetworkImage('${(attachments.first)}'.formatedHelpSupportUrl));
    }
    return const SizedBox();
  }
}
