import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../config/constants/feed_design_tokens.dart';
import '../controllers/edit_birth_date_controller.dart';

class EditBirthDateView extends GetView<EditBirthDateController> {
  const EditBirthDateView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final bgColor = FeedDesignTokens.cardBg(context);
    final dividerColor = FeedDesignTokens.divider(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: textPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Birthday'.tr,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: dividerColor, height: 0.5),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date picker ──
                Text('Date of birth'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textSecondary.withValues(alpha: 0.3)),
                  ),
                  child: DatePickerWidget(
                    looping: true,
                    firstDate: DateTime(1950, 01, 01),
                    lastDate: DateTime.now().subtract(const Duration(days: 4750)),
                    initialDate: controller.selectedDate.value,
                    dateFormat: 'dd-MMM-yyyy',
                    locale: DatePicker.localeFromString('en'),
                    onChange: (DateTime newDate, _) {
                      controller.selectedDate.value = newDate;
                    },
                    pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(color: textPrimary, fontSize: 17),
                      dividerColor: PRIMARY_COLOR,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Show type dropdown ──
                Text('Display'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textSecondary.withValues(alpha: 0.3)),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedViewType.value,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    icon: Icon(Icons.arrow_drop_down, color: textSecondary),
                    dropdownColor: bgColor,
                    style: TextStyle(fontSize: 15, color: textPrimary),
                    onChanged: (newValue) {
                      controller.selectedViewType.value = newValue ?? '';
                    },
                    items: controller.viewTypeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Who can see this? ──
                _buildPrivacyRow(
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  privacy: controller.selectedPrivacyModel.value?.privacy,
                  onTap: () => _showPrivacyPicker(context, textPrimary, textSecondary, bgColor),
                ),

                const SizedBox(height: 24),

                // ── Save button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.updateBirthday(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Save'.tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrivacyPicker(BuildContext context, Color textPrimary, Color textSecondary, Color bgColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        final options = [
          {'label': 'Public', 'icon': Icons.public, 'value': 'public'},
          {'label': 'Your friends', 'icon': Icons.group, 'value': 'friends'},
          {'label': 'Only me', 'icon': Icons.lock, 'value': 'only_me'},
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Who can see this?'.tr,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary)),
              ),
              ...options.map((o) => ListTile(
                    leading: Icon(o['icon'] as IconData, color: PRIMARY_COLOR),
                    title: Text(o['label'] as String, style: TextStyle(color: textPrimary)),
                    trailing: controller.selectedPrivacyModel.value?.privacy == o['value']
                        ? const Icon(Icons.check, color: PRIMARY_COLOR)
                        : null,
                    onTap: () {
                      controller.selectedPrivacyModel.value = controller.getPrivacyModel(o['value'] as String);
                      controller.getPrivacyDescription(o['value'] as String);
                      Get.back();
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrivacyRow({
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    String? privacy,
    VoidCallback? onTap,
  }) {
    String label = 'Public';
    if (privacy != null) {
      final p = privacy.toLowerCase();
      if (p == 'friends') label = 'Your friends';
      else if (p == 'only_me' || p == 'onlyme') label = 'Only me';
    }
    return Column(
      children: [
        Divider(height: 0.5, color: dividerColor),
        const SizedBox(height: 16),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Who can see this?'.tr,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
                    const SizedBox(height: 2),
                    Text(label, style: TextStyle(fontSize: 14, color: textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: textSecondary),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Divider(height: 0.5, color: dividerColor),
      ],
    );
  }
}
