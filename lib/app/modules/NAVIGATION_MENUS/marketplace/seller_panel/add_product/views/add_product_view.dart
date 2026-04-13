import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/add_product_controller.dart';

/// Multi-step Add Product form — 5 steps per plan section 6.9:
/// 1. General Info  2. Media  3. Pricing  4. Shipping  5. Store & Status
class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
              final label = controller.isEditMode ? 'Edit Product' : 'Add Product';
              return Text(
                '$label (${controller.currentStep.value + 1}/${AddProductController.totalSteps})',
                style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18),
              );
            }),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
      ),
      body: Column(
        children: [
          // Step indicator
          _StepIndicator(),
          // Step pages
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1General(),
                _Step2Media(),
                _Step3Pricing(),
                _Step4Shipping(),
                _Step5StoreStatus(),
              ],
            ),
          ),
          // Navigation buttons
          _BottomNav(),
        ],
      ),
    );
  }
}

// ─── Step Indicator ────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.sectionSpacing,
            vertical: 8,
          ),
          child: Row(
            children: List.generate(AddProductController.totalSteps, (i) {
              final isActive = i <= c.currentStep.value;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? MarketplaceDesignTokens.pricePrimary
                        : MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ));
  }
}

// ─── Bottom Navigation ─────────────────────────────────────
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return Obx(() => Container(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          decoration: BoxDecoration(
            color: MarketplaceDesignTokens.cardBg(context),
            border: Border(
              top: BorderSide(
                  color: MarketplaceDesignTokens.cardBorder(context)),
            ),
          ),
          child: Row(
            children: [
              if (c.currentStep.value > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: c.prevStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MarketplaceDesignTokens.pricePrimary,
                      side: const BorderSide(
                          color: MarketplaceDesignTokens.pricePrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              if (c.currentStep.value > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: c.isSaving.value
                      ? null
                      : () {
                          if (c.currentStep.value ==
                              AddProductController.totalSteps - 1) {
                            c.saveProduct();
                          } else {
                            c.nextStep();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.pricePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusMd),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: c.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          c.currentStep.value ==
                                  AddProductController.totalSteps - 1
                              ? (c.isEditMode ? 'Update Product' : 'Save Product')
                              : 'Next',
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}

// ─── Step 1: General Info ──────────────────────────────────
class _Step1General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return ListView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
      children: [
        Text('General Info',
            style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),

        // Listing Type
        Text('Listing Type',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Row(
              children: [
                _TypeChip('Item', 'item', c.listingType.value,
                    () => c.listingType.value = 'item'),
                const SizedBox(width: 8),
                _TypeChip('Vehicle', 'vehicle', c.listingType.value,
                    () => c.listingType.value = 'vehicle'),
                const SizedBox(width: 8),
                _TypeChip('Property', 'property', c.listingType.value,
                    () => c.listingType.value = 'property'),
              ],
            )),
        const SizedBox(height: 16),

        // Product name
        _InputField(label: 'Product Name *', controller: c.productNameCtrl),
        const SizedBox(height: 12),

        // Category dropdown
        Obx(() => _DropdownField<String>(
              label: 'Category *',
              value: c.selectedCategory.value.isEmpty
                  ? null
                  : c.selectedCategory.value,
              items: c.categories
                  .map((cat) => DropdownMenuItem<String>(
                        value: cat['category'] as String? ?? '',
                        child: Text(cat['category'] as String? ?? ''),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) c.selectedCategory.value = val;
              },
              isLoading: c.isCategoriesLoading.value,
            )),
        const SizedBox(height: 12),

        // Brand dropdown
        Obx(() => _DropdownField<String>(
              label: 'Brand',
              value: c.selectedBrand.value.isEmpty
                  ? null
                  : c.selectedBrand.value,
              items: c.brands
                  .map((b) => DropdownMenuItem<String>(
                        value: b['brand_name'] as String? ?? '',
                        child: Text(b['brand_name'] as String? ?? ''),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) c.selectedBrand.value = val;
              },
              isLoading: c.isBrandsLoading.value,
            )),
        const SizedBox(height: 12),

        // Condition
        Text('Condition',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: [
                _TypeChip('New', 'new', c.selectedCondition.value,
                    () => c.selectedCondition.value = 'new'),
                _TypeChip('Like New', 'used_like_new', c.selectedCondition.value,
                    () => c.selectedCondition.value = 'used_like_new'),
                _TypeChip('Good', 'used_good', c.selectedCondition.value,
                    () => c.selectedCondition.value = 'used_good'),
                _TypeChip('Fair', 'used_fair', c.selectedCondition.value,
                    () => c.selectedCondition.value = 'used_fair'),
              ],
            )),
        const SizedBox(height: 12),

        // Description
        _InputField(
          label: 'Description',
          controller: c.descriptionCtrl,
          maxLines: 4,
        ),
        const SizedBox(height: 12),

        // ── Vehicle-specific fields ──
        Obx(() {
          if (c.listingType.value != 'vehicle') return const SizedBox.shrink();
          return _VehicleFields();
        }),

        // ── Property-specific fields ──
        Obx(() {
          if (c.listingType.value != 'property') return const SizedBox.shrink();
          return _PropertyFields();
        }),

        // Hide from friends
        Obx(() => SwitchListTile(
              title: Text('Hide from friends',
                  style: MarketplaceDesignTokens.bodyText(context)),
              value: c.hideFromFriends.value,
              onChanged: (v) => c.hideFromFriends.value = v,
              activeColor: MarketplaceDesignTokens.pricePrimary,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }
}

// ─── Step 2: Media ─────────────────────────────────────────
class _Step2Media extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return ListView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
      children: [
        Text('Product Images',
            style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18)),
        const SizedBox(height: 4),
        Obx(() => Text(
              '${c.productImages.length}/${AddProductController.maxImages} images',
              style: MarketplaceDesignTokens.statLabel(context),
            )),
        const SizedBox(height: 16),

        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Add image button
                if (c.productImages.length < AddProductController.maxImages)
                  GestureDetector(
                    onTap: c.pickImages,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MarketplaceDesignTokens.pricePrimary,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              color: MarketplaceDesignTokens.pricePrimary,
                              size: 28),
                          SizedBox(height: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 11,
                              color: MarketplaceDesignTokens.pricePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Image thumbnails
                ...List.generate(c.productImages.length, (i) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                        child: Image.file(
                          File(c.productImages[i].path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => c.removeImage(i),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                      if (i == 0)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: MarketplaceDesignTokens.pricePrimary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    MarketplaceDesignTokens.radiusSm),
                                bottomRight: Radius.circular(
                                    MarketplaceDesignTokens.radiusSm),
                              ),
                            ),
                            child: const Text(
                              'Cover',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            )),
      ],
    );
  }
}

// ─── Step 3: Pricing ───────────────────────────────────────
class _Step3Pricing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return ListView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
      children: [
        Text('Pricing',
            style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _InputField(
          label: 'Base Price (€) *',
          controller: c.mainPriceCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        _InputField(
          label: 'Selling Price (€) *',
          controller: c.sellPriceCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        _InputField(
          label: 'Stock',
          controller: c.stockCtrl,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'VAT %',
                controller: c.vatCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Tax %',
                controller: c.taxCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Variants toggle
        Obx(() => SwitchListTile(
              title: Text('Has Variants (Size, Color, etc.)',
                  style: MarketplaceDesignTokens.bodyText(context)),
              value: c.hasVariant.value,
              onChanged: (v) => c.hasVariant.value = v,
              activeColor: MarketplaceDesignTokens.pricePrimary,
              contentPadding: EdgeInsets.zero,
            )),

        // Variant list
        Obx(() {
          if (!c.hasVariant.value) return const SizedBox.shrink();
          return Column(
            children: [
              ...List.generate(c.variants.length, (i) {
                return _VariantRow(index: i);
              }),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: c.addVariant,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Variant'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MarketplaceDesignTokens.pricePrimary,
                  side: const BorderSide(
                      color: MarketplaceDesignTokens.pricePrimary),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _VariantRow extends StatelessWidget {
  final int index;
  const _VariantRow({required this.index});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: MarketplaceDesignTokens.cardBorder(context)),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Variant ${index + 1}',
                  style: MarketplaceDesignTokens.bodyTextSmall(context)
                      .copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: () => c.removeVariant(index),
                child: const Icon(Icons.delete_outline,
                    size: 18, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'SKU',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => c.variants[index]['sku'] = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => c.variants[index]['sell_price'] = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => c.variants[index]['stock'] = v,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Step 4: Shipping ──────────────────────────────────────
class _Step4Shipping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return ListView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
      children: [
        Text('Shipping',
            style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _InputField(
          label: 'Weight (kg)',
          controller: c.weightCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'Length (cm)',
                controller: c.lengthCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Width (cm)',
                controller: c.widthCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Height (cm)',
                controller: c.heightCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => SwitchListTile(
              title: Text('Free Shipping',
                  style: MarketplaceDesignTokens.bodyText(context)),
              value: c.freeShipping.value,
              onChanged: (v) => c.freeShipping.value = v,
              activeColor: MarketplaceDesignTokens.pricePrimary,
              contentPadding: EdgeInsets.zero,
            )),
        Obx(() {
          if (c.freeShipping.value) return const SizedBox.shrink();
          return _InputField(
            label: 'Shipping Rate (€)',
            controller: c.shippingChargeCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          );
        }),
      ],
    );
  }
}

// ─── Step 5: Store & Status ────────────────────────────────
class _Step5StoreStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return ListView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
      children: [
        Text('Store & Status',
            style: MarketplaceDesignTokens.heading(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),

        // Store selection
        Obx(() => _DropdownField<String>(
              label: 'Store *',
              value: c.selectedStoreId.value.isEmpty
                  ? null
                  : c.selectedStoreId.value,
              items: c.stores
                  .map((s) => DropdownMenuItem<String>(
                        value: s['_id']?.toString() ?? '',
                        child: Text(s['name'] as String? ?? 'Untitled'),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) c.selectedStoreId.value = val;
              },
              isLoading: c.isStoresLoading.value,
            )),
        const SizedBox(height: 16),

        // Tags
        _InputField(
          label: 'Tags (comma-separated)',
          controller: c.tagsCtrl,
        ),
        const SizedBox(height: 16),

        // Status
        Text('Status',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Draft'),
                  subtitle: const Text('Save without publishing'),
                  value: 'draft',
                  groupValue: c.productStatus.value,
                  onChanged: (v) {
                    if (v != null) c.productStatus.value = v;
                  },
                  activeColor: MarketplaceDesignTokens.pricePrimary,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: const Text('Published'),
                  subtitle: const Text('Visible to buyers immediately'),
                  value: 'published',
                  groupValue: c.productStatus.value,
                  onChanged: (v) {
                    if (v != null) c.productStatus.value = v;
                  },
                  activeColor: MarketplaceDesignTokens.pricePrimary,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            )),
      ],
    );
  }
}

// ─── Vehicle Fields ────────────────────────────────────────
class _VehicleFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle Details',
            style: MarketplaceDesignTokens.sectionTitle(context)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InputField(label: 'Make *', controller: c.vehicleMakeCtrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(label: 'Model *', controller: c.vehicleModelCtrl),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'Year',
                controller: c.vehicleYearCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Mileage (km)',
                controller: c.vehicleMileageCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Fuel Type',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: [
                _TypeChip('Petrol', 'petrol', c.vehicleFuelType.value,
                    () => c.vehicleFuelType.value = 'petrol'),
                _TypeChip('Diesel', 'diesel', c.vehicleFuelType.value,
                    () => c.vehicleFuelType.value = 'diesel'),
                _TypeChip('Electric', 'electric', c.vehicleFuelType.value,
                    () => c.vehicleFuelType.value = 'electric'),
                _TypeChip('Hybrid', 'hybrid', c.vehicleFuelType.value,
                    () => c.vehicleFuelType.value = 'hybrid'),
              ],
            )),
        const SizedBox(height: 12),
        Text('Transmission',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: [
                _TypeChip('Automatic', 'automatic', c.vehicleTransmission.value,
                    () => c.vehicleTransmission.value = 'automatic'),
                _TypeChip('Manual', 'manual', c.vehicleTransmission.value,
                    () => c.vehicleTransmission.value = 'manual'),
              ],
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Property Fields ───────────────────────────────────────
class _PropertyFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Property Details',
            style: MarketplaceDesignTokens.sectionTitle(context)),
        const SizedBox(height: 12),
        Text('Property Type',
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TypeChip('House', 'house', c.propertyType.value,
                    () => c.propertyType.value = 'house'),
                _TypeChip('Apartment', 'apartment', c.propertyType.value,
                    () => c.propertyType.value = 'apartment'),
                _TypeChip('Land', 'land', c.propertyType.value,
                    () => c.propertyType.value = 'land'),
                _TypeChip('Commercial', 'commercial', c.propertyType.value,
                    () => c.propertyType.value = 'commercial'),
              ],
            )),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'Bedrooms',
                controller: c.propertyBedroomsCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Bathrooms',
                controller: c.propertyBathroomsCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InputField(
          label: 'Area (sq ft)',
          controller: c.propertyAreaCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        _InputField(
          label: 'Location / Address',
          controller: c.propertyLocationCtrl,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isLoading;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                items: items,
                onChanged: onChanged,
                isExpanded: true,
                hint: Text('Select $label'),
                isDense: true,
              ),
            ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _TypeChip(this.label, this.value, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isActive = value == selected;
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
      selectedColor:
          MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive
            ? MarketplaceDesignTokens.pricePrimary
            : MarketplaceDesignTokens.textSecondary(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      side: BorderSide(
        color: isActive
            ? MarketplaceDesignTokens.pricePrimary
            : MarketplaceDesignTokens.cardBorder(context),
      ),
    );
  }
}
