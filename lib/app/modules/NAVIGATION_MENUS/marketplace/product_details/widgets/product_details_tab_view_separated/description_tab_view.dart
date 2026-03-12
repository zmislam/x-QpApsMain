import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../controllers/product_details_controller.dart';
import 'package:get/get.dart';

class ProductDescriptionTabView extends StatelessWidget {
  final ProductDetailsController controller;
  const ProductDescriptionTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: controller.productDetailsList.value.first.description != null &&
              controller.productDetailsList.value.first.description!.isNotEmpty
          ? SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: HtmlWidget(
                '''
                                        <div style="color: #4A4A4A; text-align: justify;">
                  ${controller.productDetailsList.value.first.description.toString().replaceAll('\n', '<br />')}
                                      </div>
                                      ''',
                textStyle: TextStyle(
                  color: Colors.blue[600],
                ),
              ),
            )
          : Center(
              child: Text('No Description Available'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
