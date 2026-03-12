import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/profile_navigator.dart';
import '../controllers/settings_privacy_controller.dart';
import '../models/block_list_model.dart';
import '../widgets/block_list_card.dart';
import '../../../../config/constants/color.dart';

class BlockListView extends GetView<SettingsPrivacyController> {
  const BlockListView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBlockList();
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
            height: 1.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Block List'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.blockList.value.isEmpty) {
          return Center(
            child: Text('No Blocked Person is Listed!'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: PRIMARY_COLOR),
            ),
          );
        } else {
          return Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Total Blocked'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextSpan(
                            text: ' (${controller.blockList.value.length.toString()})'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.blockList.value.length,
                  itemBuilder: (context, index) {
                    Blocklist blockListed = controller.blockList.value[index];
                    return InkWell(
                      onTap: () {
                        ProfileNavigator.navigateToProfile(
                            username: blockListed.blockedTo?.username ?? '',
                            isFromReels: 'false');
                      },
                      child: BlockListCard(
                        model: blockListed,
                        controller: controller,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
