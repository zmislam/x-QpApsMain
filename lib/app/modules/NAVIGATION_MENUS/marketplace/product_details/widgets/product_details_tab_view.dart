import 'package:flutter/material.dart';
import '../controllers/product_details_controller.dart';
import 'product_details_tab.dart';
import 'product_details_tab_view_separated/description_tab_view.dart';
import 'product_details_tab_view_separated/policy_tab_view.dart';
import 'product_details_tab_view_separated/reviews_tab_view.dart';
import 'product_details_tab_view_separated/specification_tab_view.dart';

class ProductDetailsTabView extends StatelessWidget {
  final ProductDetailsController controller;
  const ProductDetailsTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ProductDetailsTab(
      tabTitles:  ['Specification', 'Description', 'Reviews', 'Policy'],
      tabContents: [
        SpecificationTabView(controller: controller),
        ProductDescriptionTabView(controller: controller),
        ProductReviewsTabView(controller: controller),
        ProductPolicyTabView(controller: controller),
      ],
    );
  }



  String _buildDynamicTableRowsForDescription() {
    final description =
        controller.productDetailsList.value.first.description ?? [];
    StringBuffer htmlBuffer = StringBuffer();

    htmlBuffer.writeln('''
      <tr>
        <td style="text-align: left; padding: 8px;  font-weight: bold;">$description</td>
      </tr>
    ''');

    return htmlBuffer.toString();
  }
}
