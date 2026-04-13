import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../utils/currency_helper.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../controllers/cart_controller.dart';
import '../models/my_cart_model.dart';

class CartReviewStep extends GetView<CartController> {
  const CartReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMarketplaceProduct.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.storeDetailsList.isEmpty ||
          controller.storeDetailsList
              .every((s) => s.myProduct == null || s.myProduct!.isEmpty)) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.EMPTY_CART_ICON, height: 150, width: 150),
              const SizedBox(height: 16),
              Text('Your cart is empty',
                  style: MarketplaceDesignTokens.sectionTitle(context)),
              const SizedBox(height: 8),
              Text(
                'Browse products and add them to your cart',
                style: TextStyle(
                  fontSize: 13,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceDesignTokens.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusMd),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                ),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Per-store sections
            ...controller.storeDetailsList
                .map((store) => _buildStoreSection(context, store)),

            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Order summary card
            _buildOrderSummary(context),

            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceDesignTokens.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusMd),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to Address',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildStoreSection(BuildContext context, StoreData store) {
    final storeId = store.storeId ?? '';
    RxDouble? subTotalRx = controller.storeDiscountedSubTotals[storeId];
    double defaultSubTotal = controller.calculateSubTotalForStore(store);
    subTotalRx ??= defaultSubTotal.obs;

    return Container(
      margin:
          const EdgeInsets.only(bottom: MarketplaceDesignTokens.sectionSpacing),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store header
          Container(
            padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MarketplaceDesignTokens.cardRadius)),
            ),
            child: Row(
              children: [
                Icon(Icons.store,
                    color: MarketplaceDesignTokens.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.storeName ?? 'Store',
                    style: MarketplaceDesignTokens.productName(context),
                  ),
                ),
                Text(
                  '${store.myProduct?.length ?? 0} items',
                  style: MarketplaceDesignTokens.cardSubtext(context),
                ),
              ],
            ),
          ),

          // Products
          ...store.myProduct?.map((product) => Dismissible(
                    key: ValueKey(product.cartId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.shade50,
                      child: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 28),
                    ),
                    confirmDismiss: (_) async {
                      await controller.deleteCartItem(
                          cartId: product.cartId);
                      return false; // controller refreshes list
                    },
                    child: _buildProductCard(context, product),
                  )) ??
              [],

          // Per-store pricing
          Padding(
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            child: Column(
              children: [
                _buildPriceRow(context, 'Subtotal',
                    CurrencyHelper.formatPrice(defaultSubTotal)),
                _buildPriceRow(
                    context,
                    'Shipping',
                    store.myProduct?.first.shippingCharge != null &&
                            store.myProduct!.first.shippingCharge! > 0
                        ? CurrencyHelper.formatPrice(store.myProduct?.first.shippingCharge)
                        : 'Free',
                    valueColor: Colors.green),
                if (controller.isCouponApplied[storeId] == true)
                  _buildPriceRow(
                    context,
                    'Discount (${controller.appliedCouponText[storeId]})',
                    '-${CurrencyHelper.formatPrice(defaultSubTotal - subTotalRx.value)}',
                    valueColor: Colors.red,
                  ),
                _buildPriceRow(
                  context,
                  'VAT',
                  '+${CurrencyHelper.formatPrice(controller.calculateTaxForStore(store))}',
                  valueColor: MarketplaceDesignTokens.primary,
                ),
                const Divider(),
                _buildPriceRow(
                  context,
                  'Total',
                  CurrencyHelper.formatPrice(controller.calculateTotalForStore(store)),
                  isBold: true,
                ),

                const SizedBox(height: 8),

                // Coupon input
                _buildCouponInput(context, storeId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, MyProduct product) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            child: product.media != null && product.media!.isNotEmpty
                ? CustomCachedNetworkImage(
                    imageUrl:
                        (product.media?.first ?? '').formatedProductUrlLive,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset(AppAssets.DEFAULT_IMAGE,
                        width: 80, height: 80, fit: BoxFit.cover),
                    placeholderImage: AppAssets.DEFAULT_IMAGE,
                  )
                : Image.asset(AppAssets.DEFAULT_IMAGE,
                    width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
                  style: MarketplaceDesignTokens.productName(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (product.productVariants?.attribute != null)
                  Text(
                    product.productVariants!.attribute!
                        .map((a) => '${a.name}: ${a.value}')
                        .join(', '),
                    style: MarketplaceDesignTokens.cardSubtext(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      CurrencyHelper.formatPrice(product.productVariants?.sellPrice),
                      style: MarketplaceDesignTokens.productPrice,
                    ),
                    const Spacer(),
                    // Quantity control
                    _buildQuantityControl(context, product),
                  ],
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            onPressed: () =>
                controller.deleteCartItem(cartId: product.cartId),
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            tooltip: 'Remove from cart',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context, MyProduct product) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(
            icon: Icons.remove,
            onTap: product.quantity! > 1
                ? () => controller.updateCartProductQuantity(
                    cartId: product.cartId, quantity: -1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('${product.quantity}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14)),
          ),
          _buildQtyButton(
            icon: Icons.add,
            onTap: () => controller.updateCartProductQuantity(
                cartId: product.cartId, quantity: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(
      {required IconData icon, VoidCallback? onTap}) {
    return Semantics(
      button: true,
      label: icon == Icons.add ? 'Increase quantity' : 'Decrease quantity',
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon,
              size: 18,
              color: onTap != null ? Colors.black87 : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCouponInput(BuildContext context, String storeId) {
    final textController = controller.couponCodeControllers[storeId];
    if (textController == null) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: textController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                hintStyle:
                    TextStyle(fontSize: 13, color: Colors.grey.shade500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                    borderSide:
                        BorderSide(color: MarketplaceDesignTokens.primary)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: () => controller.applyCouponForStore(storeId),
            style: ElevatedButton.styleFrom(
              backgroundColor: MarketplaceDesignTokens.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Apply',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final totalProductPrice = controller.calculateTotalProductPrice();
    final totalDiscount = controller.calculateTotalDiscount();
    final totalTax = controller.calculateTotalTax();
    final totalPayable = controller.calculateTotalPayable();

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 12),
          _buildPriceRow(context, 'Subtotal',
              CurrencyHelper.formatPrice(totalProductPrice)),
          if (totalDiscount > 0)
            _buildPriceRow(context, 'Discount',
                '-${CurrencyHelper.formatPrice(totalDiscount)}',
                valueColor: Colors.red),
          _buildPriceRow(
              context, 'VAT', '+${CurrencyHelper.formatPrice(totalTax)}',
              valueColor: MarketplaceDesignTokens.primary),
          const Divider(),
          _buildPriceRow(
              context, 'Total', CurrencyHelper.formatPrice(totalPayable),
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                fontSize: isBold ? 16 : 14,
                color: MarketplaceDesignTokens.textPrimary(context),
              )),
          Text(value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                fontSize: isBold ? 16 : 14,
                color: valueColor ??
                    MarketplaceDesignTokens.textPrimary(context),
              )),
        ],
      ),
    );
  }
}
