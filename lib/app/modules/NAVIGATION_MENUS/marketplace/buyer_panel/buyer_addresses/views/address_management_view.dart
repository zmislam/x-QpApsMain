import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/address_management_controller.dart';
import '../models/address_model.dart';

/// Address management view — list, delete addresses.
class AddressManagementView extends StatelessWidget {
  const AddressManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressManagementController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }

      if (controller.addresses.isEmpty) {
        return MarketplaceEmptyState(
          icon: Icons.location_off_outlined,
          title: 'No Saved Addresses',
          subtitle: 'Your shipping addresses will appear here after checkout.',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshAddresses,
        color: MarketplaceDesignTokens.pricePrimary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return Obx(() => _AddressCard(
                  address: address,
                  isDeleting: controller.isDeleting.value &&
                      controller.deletingAddressId.value == address.id,
                  onDelete: () => controller.deleteAddress(address.id),
                ));
          },
        ),
      );
    });
  }
}

class _AddressCard extends StatelessWidget {
  final AddressItem address;
  final bool isDeleting;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isDeleting,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: MarketplaceDesignTokens.pricePrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.recipientsName ?? 'Address',
                  style: MarketplaceDesignTokens.productName(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: MarketplaceDesignTokens.orderCancelled,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: MarketplaceDesignTokens.orderCancelled,
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          if (address.recipientsPhone != null)
            _infoRow(context, Icons.phone_outlined, address.recipientsPhone!),
          if (address.recipientsEmail != null) ...[
            const SizedBox(height: 4),
            _infoRow(context, Icons.email_outlined, address.recipientsEmail!),
          ],
          const SizedBox(height: 6),
          Text(
            address.fullAddress,
            style: MarketplaceDesignTokens.cardSubtext(context),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14,
            color: MarketplaceDesignTokens.textSecondary(context)),
        const SizedBox(width: 6),
        Text(
          text,
          style: MarketplaceDesignTokens.bodyTextSmall(context),
        ),
      ],
    );
  }
}
