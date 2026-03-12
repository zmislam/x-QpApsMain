import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../components/image.dart';
import '../../../../../../../../routes/app_pages.dart';
import '../../../../../../../../config/constants/color.dart';
import '../../../admin_page/model/admin_page_followers_model.dart';
import '../../controllers/page_profile_controller.dart';

class PageFollowers extends StatefulWidget {
  const PageFollowers({super.key});

  @override
  State<PageFollowers> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PageFollowers> {
  @override
  Widget build(BuildContext context) {
    PageProfileController controller = Get.find();
    controller.getPageFollowers(
        controller.pageProfileModel.value?.pageDetails?.id ?? '');
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Followers List'.tr,
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          const Divider(),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.pagefollowersList.value.length,
                itemBuilder: (context, index) {
                  AdminPageFollowersModel model =
                      controller.pagefollowersList.value[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        Routes.OTHERS_PROFILE,
                        arguments: {
                          'username': model.userId?.username ?? '',
                          'isFromReels': 'false'
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          RoundCornerNetworkImage(
                            imageUrl: (model.userId?.profilePic ?? '')
                                .formatedProfileUrl,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${model.userId?.firstName ?? ''} ${model.userId?.lastName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  (model.createdAt
                                      .toString()
                                      .toFormatDateOfBirth()),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: GREY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                Routes.OTHERS_PROFILE,
                                arguments: {
                                  'username': model.userId?.username ?? '',
                                  'isFromReels': 'false'
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(100, 40), // Dynamic width
                            ),
                            child: Text('View Profile'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
