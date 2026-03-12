import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';
import '../controller/admin_page_controller.dart';
import '../model/admin_page_followers_model.dart';

class AdminPageFollowers extends StatefulWidget {
  const AdminPageFollowers({super.key});

  @override
  State<AdminPageFollowers> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AdminPageFollowers> {
  @override
  Widget build(BuildContext context) {
    AdminPageController controller = Get.find();
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
                    onTap: (){
                       Get.toNamed(
                              Routes.OTHERS_PROFILE,
                              arguments:{
                                'username': model.userId?.username ?? '',
                                'isFromReels':'false'
                              },
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          RoundCornerNetworkImage(
                            imageUrl: (
                                model.userId?.profilePic ?? '').formatedProfileUrl,
                          ),
                          const SizedBox(width: 10), // Add some spacing
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
                                  overflow: TextOverflow
                                      .ellipsis, // Prevent text overflow
                                ),
                                Text(
                                  (model.createdAt.toString().toFormatDateOfBirth()),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: GREY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10), // Add spacing before button
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                Routes.OTHERS_PROFILE,
                                arguments:{
                                  'username': model.userId?.username ?? '',
                                  'isFromReels':'false'
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize:
                                  const Size(100, 40), // Minimum button size
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
          ),
        ],
      ),
    );
  }
}
