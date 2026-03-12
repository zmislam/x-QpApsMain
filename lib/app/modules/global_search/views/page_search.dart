import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/custom_page_card.dart';
import '../controllers/global_search_controller.dart';

class PageSearch extends GetWidget<GlobalSearchController> {
    PageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.allPageList.value.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Searched Pages'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  physics:   NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:   SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: controller.allPageList.value.length.clamp(0, 6),
                  itemBuilder: (context, index) {
                    final page = controller.allPageList.value[index];
                    return CustomPageCard(
                      coverPicUrl: page.coverPic ?? '',
                      pageName: page.pageName ?? '',
                      bio: page.bio ?? '',
                      pageUserName: page.pageUserName ?? '',
                    );
                  },
                ),
              ],
            )
          :   SizedBox(),
    );
  }
}
