import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/cart_controller.dart';

class AddressStep extends GetView<CartController> {
  const AddressStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Shipping Address ──
          Text('Shipping Address',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 12),

          // Saved addresses
          Obx(() {
            if (controller.addressList.isEmpty) {
              return _buildNoAddressMessage(context);
            }
            return _buildSavedAddresses(context);
          }),

          const SizedBox(height: 12),

          // Add new address toggle
          Obx(() => _buildNewAddressForm(context)),

          const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

          // ── Billing Address ──
          Text('Billing Address',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 8),

          Obx(() => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Same as shipping address',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                value: controller.sameAsShipping.value,
                activeColor: MarketplaceDesignTokens.primary,
                onChanged: (val) =>
                    controller.sameAsShipping.value = val ?? true,
              )),

          Obx(() {
            if (!controller.sameAsShipping.value) {
              return _buildBillingAddressForm(context);
            }
            return const SizedBox();
          }),

          const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: MarketplaceDesignTokens.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back,
                          color: MarketplaceDesignTokens.primary, size: 18),
                      const SizedBox(width: 4),
                      Text('Back',
                          style: TextStyle(
                              color: MarketplaceDesignTokens.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Continue to Payment',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNoAddressMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        children: [
          Icon(Icons.location_off,
              color: Colors.grey.shade400, size: 48),
          const SizedBox(height: 8),
          Text('No saved addresses',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              controller.showAddressForm.value = true;
              controller.fetchCountries();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedAddresses(BuildContext context) {
    return Obx(() => Column(
          children: [
            ...controller.addressList.map((address) {
              final isSelected =
                  controller.selectedAddressId.value == address.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                  border: Border.all(
                    color: isSelected
                        ? MarketplaceDesignTokens.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? MarketplaceDesignTokens.primary.withValues(alpha: 0.05)
                      : MarketplaceDesignTokens.cardBg(context),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? MarketplaceDesignTokens.primary
                        : Colors.grey,
                  ),
                  title: Text(
                    address.address ?? 'No Address',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    [
                      if (address.city != null)
                        address.city!.capitalizeFirst ?? '',
                      if (address.ward != null)
                        address.ward!.capitalizeFirst ?? '',
                      if (address.recipientsPhoneNumber != null)
                        address.recipientsPhoneNumber!,
                    ].where((s) => s.isNotEmpty).join(' • '),
                    style: MarketplaceDesignTokens.cardSubtext(context),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 20),
                    onPressed: () =>
                        controller.deleteAddressFromList(address.id ?? ''),
                  ),
                  onTap: () {
                    controller.selectAddress(address);
                    controller.showAddressForm.value = false;
                  },
                ),
              );
            }),
            TextButton.icon(
              onPressed: () {
                controller.showAddressForm.value =
                    !controller.showAddressForm.value;
                if (controller.showAddressForm.value) {
                  controller.fetchCountries();
                }
              },
              icon: Icon(
                  controller.showAddressForm.value
                      ? Icons.close
                      : Icons.add,
                  size: 18),
              label: Text(controller.showAddressForm.value
                  ? 'Cancel'
                  : 'Add New Address'),
            ),
          ],
        ));
  }

  Widget _buildNewAddressForm(BuildContext context) {
    if (!controller.showAddressForm.value) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Address',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Street Address',
            hint: 'Lot number, street name',
            onChanged: (val) => controller.selectedAddress.value = val,
          ),
          const SizedBox(height: 12),

          // Country
          _buildGeoDropdown(
            context: context,
            label: 'Country',
            isLoading: controller.isLoadingCountries.value,
            value: controller.selectedCountry.value.isEmpty
                ? null
                : controller.selectedCountry.value,
            items: controller.countryList,
            hint: 'Select Country',
            onChanged: controller.onCountryChanged,
          ),
          const SizedBox(height: 12),

          // State
          _buildGeoDropdown(
            context: context,
            label: 'State / Province',
            isLoading: controller.isLoadingStates.value,
            value: controller.selectedState.value.isEmpty
                ? null
                : controller.selectedState.value,
            items: controller.stateList,
            hint: controller.selectedCountry.value.isEmpty
                ? 'Select country first'
                : 'Select State',
            onChanged: controller.stateList.isEmpty
                ? null
                : controller.onStateChanged,
          ),
          const SizedBox(height: 12),

          // City
          _buildGeoDropdown(
            context: context,
            label: 'City',
            isLoading: controller.isLoadingCities.value,
            value: controller.selectedCity.value.isEmpty
                ? null
                : controller.selectedCity.value,
            items: controller.cityList,
            hint: controller.selectedState.value.isEmpty
                ? 'Select state first'
                : 'Select City',
            onChanged:
                controller.cityList.isEmpty ? null : controller.onCityChanged,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Zip Code',
            hint: 'Zip Code',
            onChanged: (val) => controller.selectedZipCode.value = val,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Recipient Name',
            hint: 'Full name',
            onChanged: (val) => controller.recipientName.value = val,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Phone Number',
            hint: 'Phone number',
            onChanged: (val) => controller.contact.value = val,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Save to address book',
                style: TextStyle(fontSize: 14)),
            value: controller.saveAddress.value,
            activeColor: MarketplaceDesignTokens.primary,
            onChanged: (val) => controller.saveAddress.value = val ?? false,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingAddressForm(BuildContext context) {
    if (controller.sameAsShipping.value) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Billing Address',
            hint: 'Street address',
            onChanged: (val) => controller.billingAddress.value = val,
          ),
          const SizedBox(height: 12),

          _buildGeoDropdown(
            context: context,
            label: 'Country',
            isLoading: controller.isLoadingBillingCountries.value,
            value: controller.billingCountry.value.isEmpty
                ? null
                : controller.billingCountry.value,
            items: controller.billingCountryList,
            hint: 'Select Country',
            onChanged: (val) {
              controller.onBillingCountryChanged(val);
            },
            onFirstOpen: () => controller.fetchBillingCountries(),
          ),
          const SizedBox(height: 12),

          _buildGeoDropdown(
            context: context,
            label: 'State / Province',
            isLoading: controller.isLoadingBillingStates.value,
            value: controller.billingState.value.isEmpty
                ? null
                : controller.billingState.value,
            items: controller.billingStateList,
            hint: 'Select State',
            onChanged: controller.billingStateList.isEmpty
                ? null
                : (val) => controller.onBillingStateChanged(val),
          ),
          const SizedBox(height: 12),

          _buildGeoDropdown(
            context: context,
            label: 'City',
            isLoading: controller.isLoadingBillingCities.value,
            value: controller.billingCity.value.isEmpty
                ? null
                : controller.billingCity.value,
            items: controller.billingCityList,
            hint: 'Select City',
            onChanged: controller.billingCityList.isEmpty
                ? null
                : (val) => controller.onBillingCityChanged(val),
          ),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Recipient Name',
            hint: 'Full name',
            onChanged: (val) => controller.billingRecipientName.value = val,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            label: 'Phone Number',
            hint: 'Phone number',
            onChanged: (val) => controller.billingPhone.value = val,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // ── Shared field builders ──

  Widget _buildTextField({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildGeoDropdown({
    required BuildContext context,
    required String label,
    required bool isLoading,
    required String? value,
    required RxList<String> items,
    required String hint,
    required ValueChanged<String?>? onChanged,
    VoidCallback? onFirstOpen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        if (isLoading)
          const SizedBox(
              height: 48,
              child: Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))))
        else
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                initialValue: value,
                items: items
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: onChanged,
                hint: Text(hint,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade500)),
                isExpanded: true,
                onTap: onFirstOpen,
              )),
      ],
    );
  }
}
