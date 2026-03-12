import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/button.dart';
import '../controllers/boost_reels_controller.dart';

class KeywordSelectionWidget extends StatelessWidget {
  final BoostReelsController controller = Get.find();

  KeywordSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => openKeywordSelection(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              return controller.selectedKeywords.isEmpty
                  ? SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('Select keywords...'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ))
                  : SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.selectedKeywords.map((keyword) {
                          return Chip(
                            backgroundColor: Colors.grey.withValues(alpha: 0.3),
                            label: Text(keyword),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => controller.removeKeyword(keyword),
                          );
                        }).toList(),
                      ),
                    );
            }),
          ),
        ),
      ],
    );
  }

  void openKeywordSelection(BuildContext context) {
    TextEditingController keywordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: keywordController,
                  decoration: InputDecoration(
                    hintText: 'Enter keyword or select from list'.tr,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addKeywordAndClear(keywordController);
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    _addKeywordAndClear(keywordController);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.keywordsList.length,
                    itemBuilder: (context, index) {
                      String keyword = controller.keywordsList[index];
                      return ListTile(
                        title: Text(keyword),
                        onTap: () {
                          controller.addKeyword(keyword);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () => Get.back(),
                    text: 'Close'.tr,
                    verticalPadding: 15,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _addKeywordAndClear(TextEditingController keywordController) {
    String keyword = keywordController.text.trim();
    if (keyword.isNotEmpty) {
      controller.addKeyword(keyword);
      keywordController.clear(); // ✅ Clears input after adding
    }
  }
}
