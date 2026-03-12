// Create a reusable custom search field widget
import 'package:flutter/material.dart';

import '../../../../../config/constants/color.dart';
import '../controllers/marketplace_controller.dart';
import 'package:get/get.dart';

class CustomSearchField extends StatelessWidget {
  final bool showSuggestions;
  final MarketplaceController controller;

  const CustomSearchField({
    super.key,
    required this.showSuggestions,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.searchController,
      decoration: _buildDecoration(),
      onChanged: (value) => _handleSearchChange(value),
      onFieldSubmitted: (value) => controller.getMarketPlaceProduct(),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      suffixIcon: showSuggestions
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.searchController.clear();
                controller.getMarketPlaceProduct();
                controller.suggestedProductList.value.clear();
              },
            )
          : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: PRIMARY_COLOR),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      hintText: 'Search on marketplace'.tr,
      prefixIcon: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(Icons.search, color: Colors.grey),
      ),
      border: InputBorder.none,
    );
  }

  void _handleSearchChange(String value) {
    controller.debounce(() {
      if (showSuggestions) {
        // Only handle suggestions for the suggestion-enabled field
        if (value.isNotEmpty) {
          controller.getSuggestedProducts();
        } else {
          controller.suggestedProductList.value.clear();
          controller.getMarketPlaceProduct();
        }
      } else {
        // For non-suggestion field, always search marketplace directly
        controller.getMarketPlaceProduct();
        // Clear suggestions if they exist from previous searches
        if (controller.suggestedProductList.value.isNotEmpty) {
          controller.suggestedProductList.value.clear();
        }
      }
    });
  }
}
