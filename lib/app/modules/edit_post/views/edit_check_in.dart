import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/color.dart';
import '../controllers/edit_post_controller.dart';

class EditCheckIn extends GetView<EditPostController> {
    EditCheckIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('Choose Location'.tr,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:   EdgeInsetsDirectional.symmetric(
                vertical: 20, horizontal: 16),
            child: TextFormField(
              decoration:   InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search location'.tr,
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none),
              onChanged: (value) async {
                await controller.getLocation(value.toString());
                if (value.isEmpty) {
                  controller.locationList.value.clear();
                  await controller.getLocation('dhaka');
                }
              },
            ),
          ),
          Expanded(
              child: Obx(
            () => controller.isLocationLoading.value == true
                ?   Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.locationList.value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          debugPrint(
                              'edit location id ...............${controller.locationId.value}');

                          controller.locationId.value = controller
                              .locationList.value[index].locationName
                              .toString();
                          Get.back(
                              result: controller.locationList.value[index]);

                          debugPrint(
                              'edit location id ...............${controller.locationId.value}');
                        },
                        leading:   Icon(
                          Icons.location_on,
                          size: 37,
                          color: PRIMARY_COLOR,
                        ),
                        title: Text(controller
                            .locationList.value[index].locationName
                            .toString()),
                      );
                    }),
          ))
        ],
      ),
    );
  }
}
