import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../components/button.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../edit_post_comment/controllers/edit_post_comment_controller.dart';
import '../../../../../../config/constants/color.dart';

class EditPostCommentView extends GetView<EditPostCommentController> {
  const EditPostCommentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: PRIMARY_GREY_DIVIDER_COLOR,
              height: 1.0,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text('Edit Comment'.tr,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          // backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            /*============================================================Comment Description=========================*/

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.bioLength.value > 400
                              ? Colors.red
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          controller: controller.editCommentController,
                          maxLines: 10,
                          
                          // maxLength: 100,
                          decoration: const InputDecoration(
                           
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: '',
                          ),
                          // onChanged: (value) {
                          //   controller.updateBioLength(value.length);
                          // },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                 
                   
                  ],
                );
              }),
            ),

            const SizedBox(height: 10),

           
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     PrimaryButton(
                      fontSize: 15,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      onPressed: () {
                        // controller.onTapEditBioPatch();
                        Get.back();
                      },
                      text: 'Cancel'.tr,
                      horizontalPadding: 20,
                      verticalPadding: 10,
                    ),
                  const  SizedBox(width: 20),
                    PrimaryButton(
                      fontSize: 15,
                      borderRadius: BorderRadius.circular(5),
                      onPressed: () {
                        controller.onTapEditCommentPost();
                      },
                      text: 'Update'.tr,
                      horizontalPadding: 20,
                      verticalPadding: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            if (controller.imageOrVideo != null &&
                        controller.imageOrVideo!.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.network(
                            ('${ApiConstant.SERVER_IP_PORT}/${controller.imageOrVideo!}'),
                            
                            // height: 100,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
          ],
        )));
  }
}
