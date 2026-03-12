import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../controllers/product_details_controller.dart';
import 'package:get/get.dart';

class SpecificationTabView extends StatelessWidget {
  final ProductDetailsController controller;
  const SpecificationTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child:
          controller.productDetailsList.value.first.specification?.isNotEmpty ??
                  false
              ? HtmlWidget(
                  '''
                                        <div style="width: 100%;">
                    <table style="width: 100%; border-collapse: collapse;">
                      ${_buildDynamicTableRowsForSpecification()}
                                                </table>
                                              </div>
                                    ''',
                )
              : Center(
                  child: Text('No Specification Available'.tr,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
    );
  }

  String _buildDynamicTableRowsForSpecification() {
    final specifications =
        controller.productDetailsList.value.first.specification ?? [];
    StringBuffer htmlBuffer = StringBuffer();

    for (var spec in specifications) {
      htmlBuffer.writeln('''
      <tr>
        <td style="text-align: left; padding: 8px; font-weight: bold;">${spec.label ?? ''}</td>
        <td style="text-align: left; padding: 8px;">${spec.value ?? 'N/A'}</td>
      </tr>
    ''');
    }

    return htmlBuffer.toString();
  }
}
