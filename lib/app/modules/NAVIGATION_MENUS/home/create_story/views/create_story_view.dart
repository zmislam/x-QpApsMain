import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/constants/app_assets.dart';
import '../controllers/create_story_controller.dart';

class CreateStoryView extends GetView<CreateStoryController> {
  const CreateStoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Story'.tr,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: controller.onTapCreateTextStory,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff60EFFF), // #60EFFF
                        Color(0xff0061FF), // #0061FF
                      ],
                      stops: [0.2279, 0.946], // Percentages for color stops
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height / 3,
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardTheme.color),
                      child: Center(
                        child: Text('Aa'.tr,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: controller.onTapPickImage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff40C9FF), // #40C9FF
                        Color(0xffE81CFF), // #E81CFF
                      ],
                      stops: [0.3126, 0.9992], // Percentages for color stops
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height / 3,
                  child: Center(
                    child: Container(
                        // padding: const EdgeInsets.all(50),
                        height: 120,
                        width: 120,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardTheme.color),
                        child: const Image(
                          height: 32,
                          width: 32,
                          image: AssetImage(AppAssets.DEFAULT_STORY_IMAGE),
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
