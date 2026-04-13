import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../add_product/controllers/add_product_controller.dart';
import '../../add_product/views/add_product_view.dart';
import '../controllers/edit_product_controller.dart';

/// Edit Product view — reuses the AddProductView structure
/// but wraps it with a loading state while product data loads.
class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    // The binding registers EditProductController as AddProductController
    final controller = Get.find<AddProductController>() as EditProductController;

    return Obx(() {
      if (controller.isLoadingProduct.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Product',
              style:
                  MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18),
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: MarketplaceDesignTokens.cardBg(context),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // Reuse AddProductView — EditProductController extends AddProductController
      // and is registered as AddProductController, so all widgets find it correctly.
      return const AddProductView();
    });
  }
}
