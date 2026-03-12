import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../extension/string/string_image_path.dart';
import '../models/post.dart';
import '../routes/app_pages.dart';
import 'image.dart';

class PostTagList extends StatelessWidget {
  const PostTagList({super.key, required this.postModel});

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('People who taged'.tr,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: postModel.taggedUserList?.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.OTHERS_PROFILE,
                    arguments: {
                      'username':postModel.taggedUserList![index].user?.username,
                      'isFromReels':'false'
                    });
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: NetworkCircleAvatar(
                      imageUrl: (
                          postModel.taggedUserList![index].user?.firstName ??
                              '').formatedProfileUrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      '${postModel.taggedUserList![index].user?.firstName ?? ''} ${postModel.taggedUserList![index].user?.lastName ?? ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
