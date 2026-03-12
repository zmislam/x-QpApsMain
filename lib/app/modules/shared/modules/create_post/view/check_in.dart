// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

import '../controller/create_post_controller.dart';

class CheckIn extends GetView<CreatePostController> {
  const CheckIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'.tr,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: 20, horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search location'.tr,
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none),
              onChanged: (value) async {
                // controller.locationSearch.value = value.toString();
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
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.locationList.value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          controller.locationId.value = controller
                              .locationList.value[index].locationName
                              .toString();
                          Get.back(
                              result: controller.locationList.value[index]);
                        },
                        leading: const Icon(
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
