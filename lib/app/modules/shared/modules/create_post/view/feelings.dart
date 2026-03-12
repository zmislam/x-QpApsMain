import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../components/image.dart';
import '../controller/create_post_controller.dart';

class Feelings extends GetView<CreatePostController> {
  const Feelings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How are you feeling?'.tr,
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search feelings'.tr,
                hintStyle: TextStyle(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.feelingController.value = value.toString();

                  controller.feelingSearchList.value.clear();

                  controller.feelingSearchList.value = controller
                      .feelingList.value
                      .where((feeling) => feeling.feelingName!
                          .toLowerCase()
                          .contains(
                              controller.feelingController.value.toLowerCase()))
                      .toList();

                  debugPrint(
                      'feeling search ..........${controller.feelingList}');

                  debugPrint(
                      'feeling search ..........${controller.feelingSearchList.value}');
                } else {
                  controller.feelingController.value = '';
                  controller.feelingList.value.clear();
                  controller.feelingSearchList.value.clear();
                  controller.getFeeling();
                }
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Obx(
            () => controller.isFeelingLoading.value == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.feelingController.value == ''
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 15,
                                childAspectRatio: 900 / (200 * 1.05)),
                        itemCount: controller.feelingList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              controller.feelingId.value = controller
                                  .feelingList.value[index].id
                                  .toString();
                              Get.back(
                                  result: controller.feelingList.value[index]);
                              controller.feelingController.value = '';
                              controller.feelingList.value.clear();
                              controller.feelingSearchList.value.clear();

                              controller.getFeeling();
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    NetworkCircleAvatar(
                                        imageUrl: (
                                            controller
                                                .feelingList.value[index].logo
                                                .toString()).formatedFeelingUrl),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(controller
                                        .feelingList.value[index].feelingName
                                        .toString()),
                                  ],
                                )),
                          );
                        },
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 15,
                                childAspectRatio: 900 / (200 * 1.05)),
                        itemCount: controller.feelingSearchList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              controller.feelingId.value = controller
                                  .feelingSearchList.value[index].id
                                  .toString();
                              Get.back(
                                  result: controller
                                      .feelingSearchList.value[index]);
                              controller.feelingController.value = '';
                              controller.feelingSearchList.value.clear();

                              controller.getFeeling();
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    NetworkCircleAvatar(
                                        imageUrl: (
                                            controller.feelingSearchList
                                                .value[index].logo
                                                .toString()).formatedFeelingUrl),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(controller.feelingSearchList
                                        .value[index].feelingName
                                        .toString()),
                                  ],
                                )),
                          );
                        },
                      ),
          ))
        ],
      ),
    );
  }
}
