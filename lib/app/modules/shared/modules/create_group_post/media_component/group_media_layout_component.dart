import 'package:flutter/material.dart';
import '../../../../../extension/num.dart';
import '../../../../../extension/string/string.dart';

import '../../../../../components/image.dart';
import '../../../../../models/post_media_layout_model.dart';
import '../controller/create_group_post_controller.dart';
import 'package:get/get.dart';

class GroupMediaLayoutComponent extends StatelessWidget {
  const GroupMediaLayoutComponent({
    Key? key,
    required this.createPostController,
  }) : super(key: key);

  final CreateGroupPostController createPostController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.h,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Choose a Layout'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // InkWell(
              //   onTap: () {},
              //   child: const Icon(Icons.close),
              // ),
            ],
          ),
        ),
        20.h,
        Row(children: [
          Expanded(
            child: LayoutItem(
                onTap: () {
                  createPostController.selectedMediaLayout.value =
                      createPostController.mediaLayoutlist[0];
                },
                model: createPostController.mediaLayoutlist[0]),
          ),
          10.w,
          Expanded(
            child: LayoutItem(
                onTap: () {
                  createPostController.selectedMediaLayout.value =
                      createPostController.mediaLayoutlist[1];
                },
                model: createPostController.mediaLayoutlist[1]),
          ),
          10.w,
          Expanded(
            child: LayoutItem(
                onTap: () {
                  createPostController.selectedMediaLayout.value =
                      createPostController.mediaLayoutlist[2];
                },
                model: createPostController.mediaLayoutlist[2]),
          ),
          10.w,
          Expanded(
            child: LayoutItem(
              onTap: () {
                createPostController.selectedMediaLayout.value =
                    createPostController.mediaLayoutlist[3];
              },
              model: createPostController.mediaLayoutlist[3],
            ),
          ),
          10.w,
          Expanded(
            child: LayoutItem(
              onTap: () {
                createPostController.selectedMediaLayout.value =
                    createPostController.mediaLayoutlist[4];
              },
              model: createPostController.mediaLayoutlist[4],
            ),
          ),
        ]),
      ],
    );
  }
}

class LayoutItem extends StatelessWidget {
  const LayoutItem({
    super.key,
    required this.model,
    required this.onTap,
  });
  final PostMediaLayoutModel model;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          PrimaryAssetImage(
            height: 40,
            width: 40,
            imagePath: model.iconPath,
          ),
          10.h,
          Text(
            GetStringUtils(model.title).capitalizeFirst!,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
