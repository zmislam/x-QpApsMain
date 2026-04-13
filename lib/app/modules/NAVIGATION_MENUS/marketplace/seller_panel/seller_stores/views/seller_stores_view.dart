import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/seller_stores_controller.dart';

/// Seller stores list with create, edit, delete.
class SellerStoresView extends GetView<SellerStoresController> {
  const SellerStoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add store button
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showStoreForm(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Store'),
              style: OutlinedButton.styleFrom(
                foregroundColor: MarketplaceDesignTokens.pricePrimary,
                side: const BorderSide(
                    color: MarketplaceDesignTokens.pricePrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // Store list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.stores.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }

            if (controller.stores.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.storefront_outlined,
                title: 'No stores yet',
                subtitle: 'Create your first store to start selling',
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchStores(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.stores.length,
                itemBuilder: (context, index) {
                  return _StoreCard(
                    store: controller.stores[index],
                    onEdit: () => _showStoreForm(
                      context,
                      store: controller.stores[index],
                    ),
                    onDelete: () => _confirmDelete(
                      context,
                      controller.stores[index]['_id']?.toString() ?? '',
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showStoreForm(BuildContext context, {Map<String, dynamic>? store}) {
    final isEdit = store != null;
    if (isEdit) {
      controller.populateForm(store);
    } else {
      controller.clearForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit Store' : 'Create Store',
                style: MarketplaceDesignTokens.heading(ctx),
              ),
              const SizedBox(height: 16),

              // Store image
              Center(
                child: GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    final img = controller.selectedImage.value;
                    final existingUrl = store?['image_path'] as String? ?? '';
                    return CircleAvatar(
                      radius: 40,
                      backgroundColor: MarketplaceDesignTokens.pricePrimary
                          .withValues(alpha: 0.1),
                      backgroundImage: img != null
                          ? FileImage(File(img.path))
                          : (existingUrl.isNotEmpty
                              ? NetworkImage(existingUrl) as ImageProvider
                              : null),
                      child:
                          img == null && existingUrl.isEmpty
                              ? const Icon(Icons.camera_alt_outlined,
                                  size: 28,
                                  color: MarketplaceDesignTokens.pricePrimary)
                              : null,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              _FormField(label: 'Store Name *', controller: controller.nameCtrl),
              _FormField(label: 'Category', controller: controller.categoryCtrl),
              _FormField(
                  label: 'Description',
                  controller: controller.descriptionCtrl,
                  maxLines: 3),
              _FormField(
                  label: 'Shipping Policy', controller: controller.shippingCtrl),
              _FormField(
                  label: 'Delivery Policy', controller: controller.deliveryCtrl),
              _FormField(
                  label: 'Return Policy', controller: controller.returnsCtrl),
              const SizedBox(height: 16),

              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () {
                              Navigator.pop(ctx);
                              if (isEdit) {
                                controller.updateStore(
                                    store['_id']?.toString() ?? '');
                              } else {
                                controller.saveStore();
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
                      child: controller.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(isEdit ? 'Update Store' : 'Create Store'),
                    ),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String storeId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Store'),
        content: const Text('Are you sure you want to delete this store?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteStore(storeId);
            },
            child: Text('Delete',
                style: TextStyle(color: MarketplaceDesignTokens.outOfStock)),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
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
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StoreCard({
    required this.store,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = store['name'] as String? ?? 'Untitled Store';
    final desc = store['description'] as String? ?? '';
    final imagePath = store['image_path'] as String? ?? '';
    final productCount = store['product_count'] ?? 0;
    final category = store['category_name'] as String? ?? '';

    return Container(
      margin:
          const EdgeInsets.only(bottom: MarketplaceDesignTokens.gridSpacing),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          // Store image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
            child: imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: MarketplaceDesignTokens.bodyText(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: MarketplaceDesignTokens.statLabel(context),
                  ),
                ],
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: MarketplaceDesignTokens.bodyTextSmall(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '$productCount products',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
      ),
      child: const Icon(Icons.storefront_outlined,
          color: Colors.grey, size: 24),
    );
  }
}
