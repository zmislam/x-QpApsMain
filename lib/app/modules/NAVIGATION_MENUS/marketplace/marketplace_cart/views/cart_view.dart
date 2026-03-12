import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string_image_path.dart';

import '../../../../../components/button.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../components/wallet_balance_bottomsheet.dart';
import '../controllers/cart_controller.dart';
import '../models/my_cart_model.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.wait([controller.getCartDetails(), controller.getAddressList()]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text('My QP Cart'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.storeDetailsList.isEmpty || controller.storeDetailsList.every((store) => store.myProduct == null || store.myProduct!.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.EMPTY_CART_ICON,
                  height: 150,
                  width: 150,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.storeDetailsList.map((store) => buildProductSection(context, store)),
                const SizedBox(height: 16),
                buildAddressSection(context),
                const SizedBox(height: 16),
                buildPriceSummary(context),
                const SizedBox(height: 16),
                buildCheckoutButton(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildProductSection(BuildContext context, StoreData store) {
    RxDouble? subTotalRx = controller.storeDiscountedSubTotals[store.storeId ?? ''];

    double defaultSubTotal = controller.calculateSubTotalForStore(store);
    subTotalRx ??= defaultSubTotal.obs;

    RxDouble totalRx = (subTotalRx.value + controller.calculateTaxForStore(store)).obs;

    subTotalRx.listen((newSubTotal) {
      totalRx.value = newSubTotal + controller.calculateTaxForStore(store);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            store.storeName ?? 'Unnamed Store'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...store.myProduct?.map((product) {
              return buildProductCard(context, product);
            }).toList() ??
            [],
        const SizedBox(height: 16),
        buildPriceDetail(context, 'Sub-total'.tr, '\$$defaultSubTotal'),
        buildPriceDetail(context, 'Shipping'.tr, store.myProduct?.first.shippingCharge != null ? '\$${store.myProduct?.first.shippingCharge}' : 'Free'.tr),
        // Obx(() {
        //   if (controller.isCouponApplied[store.storeId] == true) {
        // return
        controller.isCouponApplied[store.storeId] == true ? buildPriceDetail(context, 'Discount'.tr, '-\$${(defaultSubTotal - (subTotalRx.value)).toStringAsFixed(2)}', isRed: true, discountText: ' ${controller.appliedCouponText[store.storeId]}') : const SizedBox()
        //   }
        //   return const SizedBox();
        // })
        ,
        buildPriceDetail(context, 'VAT'.tr, '+\$${controller.calculateTaxForStore(store).toStringAsFixed(2)}', isGreen: true),
        // Obx(() =>
        buildPriceDetail(context, 'Total'.tr, '\$${totalRx.value.toStringAsFixed(2)}'),
        // ),
        buildCouponComponent(
          textController: controller.couponCodeControllers[store.storeId]!,
          onApplyCoupon: () {
            controller.applyCouponForStore(store.storeId!);
          },
        ),
        const Divider(height: 32, thickness: 2),
      ],
    );
  }

  Widget buildProductCard(BuildContext context, MyProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD6D6D6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // Shadow color with 25% opacity
            offset: Offset(0, 6), // X and Y offsets for the shadow
            blurRadius: 14, // Blur radius for the shadow
            spreadRadius: -8, // Spread radius for the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.media != null && product.media!.first.isNotEmpty && product.media!.first.isNotEmpty
                  ? Image.network(
                      (product.media?.first ?? '').formatedProductUrlLive,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          AppAssets.DEFAULT_IMAGE,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            // Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product.productVariants?.attribute?.map((attribute) {
                          return "${attribute.name}: ${attribute.value}";
                        }).join(', ') ?? 'No Attributes Available'}"
                    "${product.productVariants?.color?.name != null ? ', Color: ${product.productVariants?.color?.name}' : ''}\n",
                    style: TextStyle(color: Colors.grey),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${product.productVariants?.sellPrice?.toStringAsFixed(2) ?? 0}'.tr,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Quantity Selector
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Makes the row shrink to fit the content
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (product.quantity! > 1) {
                                      controller.updateCartProductQuantity(
                                        cartId: product.cartId,
                                        quantity: -1,
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('Qty: ${product.quantity}'.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.updateCartProductQuantity(
                                      cartId: product.cartId,
                                      quantity: 1,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          controller.deleteCartItem(cartId: product.cartId);
                        },
                        child: Text('Remove'.tr,
                          style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceSummary(BuildContext context) {
    // return
    //  Obx(() {
    double totalProductPrice = controller.calculateTotalProductPrice();
    double totalDiscount = controller.calculateTotalDiscount();
    double totalTax = controller.calculateTotalTax();
    double totalPayable = controller.calculateTotalPayable();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFD6D6D6),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000), // Shadow color with 25% opacity
              offset: Offset(0, 6), // X and Y offsets for the shadow
              blurRadius: 14, // Blur radius for the shadow
              spreadRadius: -8, // Spread radius for the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              buildPriceDetail(context, 'Total Product Price', '\$${totalProductPrice.toStringAsFixed(2)}'),
              buildPriceDetail(context, 'Total Discount', '-\$${totalDiscount.toStringAsFixed(2)}', isRed: true),
              buildPriceDetail(context, 'Total VAT', '+\$${totalTax.toStringAsFixed(2)}', isGreen: true),
              const Divider(),
              buildPriceDetail(context, 'Total Payable', '\$${totalPayable.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
    // });
  }

  Widget buildCouponComponent({
    required TextEditingController textController,
    required VoidCallback onApplyCoupon,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 43,
            child: TextField(
              controller: textController,
              style: TextStyle(
                fontSize: 14, // Adjust font size as needed
                height: 1.0, // Adjust line height to control text field height
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Coupon Code'.tr,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: PRIMARY_COLOR)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onApplyCoupon,
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.grey,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: const Color(0xFF4C9F88),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          ),
          child: Text('Apply Coupon'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPriceDetail(BuildContext context, String label, String value, {bool isRed = false, bool isGreen = false, String discountText = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: $discountText '.tr, style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            value.tr,
            style: TextStyle(
              color: isRed
                  ? Colors.red
                  : isGreen
                      ? Colors.green
                      : Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.teal),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                controller.setDefaultAddress(); // Set default if not set
                return Text(
                  '${controller.selectedAddress.value}\n'
                  'Contact: ${controller.contact.value}\n'
                  'Ward: ${controller.selectedWard.value.capitalizeFirst}\n'
                  'City: ${controller.selectedCity.value.capitalizeFirst}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ),
            IconButton(
              onPressed: () {
                // Toggle visibility for address book only
                controller.showAddressBook.value = !controller.showAddressBook.value;
                controller.showAddressForm.value = false; // Ensure form is hidden
              },
              icon: const Icon(Icons.book),
            ),
            IconButton(
              onPressed: () {
                // Toggle visibility for address form only
                controller.showAddressForm.value = !controller.showAddressForm.value;
                controller.showAddressBook.value = false; // Ensure address book is hidden
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const Divider(),

        // Show Address List if enabled and form is not visible
        Obx(() {
          if (controller.showAddressBook.value && !controller.showAddressForm.value) {
            return buildAddressList(context);
          } else {
            return const SizedBox();
          }
        }),

        // Show Address Form if enabled and address list is not visible
        Obx(() {
          if (controller.showAddressForm.value && !controller.showAddressBook.value) {
            return buildAddressForm(context);
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget buildAddressList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for ListView
      shrinkWrap: true, // Make the ListView take only as much space as needed
      itemCount: controller.addressList.length,
      itemBuilder: (context, index) {
        final address = controller.addressList[index];
        return ListTile(
          title: Text(address.address ?? 'No Address'),
          subtitle: Text(
            'Contact: ${address.recipientsPhoneNumber ?? ''}\n'
            'Ward: ${address.ward?.capitalizeFirst ?? 'N/A'}\n'
            'City: ${address.city?.capitalizeFirst ?? 'N/A'}',
          ),
          onTap: () {
            controller.selectAddress(address); // Update selected address
            controller.showAddressBook.value = false; // Close list after selection
          },
        );
      },
    );
  }

  Widget buildAddressForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6D6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // Shadow color with 25% opacity
            offset: Offset(0, 6), // X and Y offsets for the shadow
            blurRadius: 14, // Blur radius for the shadow
            spreadRadius: -8, // Spread radius for the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Address'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Lot number, street name'.tr,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (val) {
              controller.selectedAddress.value = val;
            },
          ),
          const SizedBox(height: 16),

          // Country Dropdown
          Text('Country'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: const OutlineInputBorder(),
            ),
            items: ['Country 1', 'Country 2']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              // Update the country in the controller
            },
            hint: Text('Select Country'.tr),
          ),

          const SizedBox(height: 16),

          // City Dropdown
          Text('City'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: const OutlineInputBorder(),
            ),
            items: ['City 1', 'City 2']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              // Update the city in the controller
            },
            hint: Text('Select City'.tr),
          ),

          const SizedBox(height: 16),

          // State/Province Dropdown
          Text('State/Province'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: const OutlineInputBorder(),
            ),
            items: ['State 1', 'State 2']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              // Update the state/province in the controller
            },
            hint: Text('Select State/Province'.tr),
          ),

          const SizedBox(height: 16),

          // Zip Code Field
          Text('Zip Code'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Zip Code'.tr,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (val) {
              // Update the zip code in the controller
            },
          ),

          const SizedBox(height: 16),

          // Recipient’s Name
          Text('Recipient’s name'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'E.g Nguyen Van A'.tr,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (val) {
              // Update recipient’s name in the controller
            },
          ),

          const SizedBox(height: 16),

          // Recipient’s Phone Number
          Text('Recipient’s phone number'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Phone number'.tr,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (val) {
              // Update phone number in the controller
            },
          ),

          const SizedBox(height: 16),

          // Save Address Checkbox
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Save address book'.tr,
              style: TextStyle(fontSize: 14),
            ),
            value: controller.saveAddress.value,
            onChanged: (val) {
              controller.saveAddress.value = val ?? false;
            },
          ),
        ],
      ),
    );
  }

  Widget buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        onPressed: () {
          if (controller.saveAddress.value) {
            showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).cardTheme.color,
              builder: (context) => CheckoutWalletBottomSheet(
                // controller: CartController(),
                totalPayable: controller.totalPayable,
              ),
            );
            // controller.placeOrder();
          } else {
            showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).cardTheme.color,
              builder: (context) => CheckoutWalletBottomSheet(
                // controller: CartController(),
                totalPayable: controller.totalPayable,
              ),
            );
          }
        },

        text: 'Checkout'.tr,
        fontSize: 15,
        verticalPadding: 15,

        // style: ElevatedButton.styleFrom(
        //   backgroundColor: PRIMARY_COLOR,
        //   padding: const EdgeInsets.symmetric(vertical: 16),
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // ),
        // child: Text(
        //   'Checkout',
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        // ),
      ),
    );
  }
}
