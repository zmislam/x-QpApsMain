import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../config/constants/feed_design_tokens.dart';
import '../controllers/add_education_controller.dart';

class AddEducationView extends GetView<AddEducationController> {
  const AddEducationView({super.key});

  @override
  Widget build(BuildContext context) {
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final bgColor = FeedDesignTokens.cardBg(context);
    final dividerColor = FeedDesignTokens.divider(context);
    final inputBg = FeedDesignTokens.inputBg(context);

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
          controller.isEditing ? 'Edit Education'.tr : 'Education'.tr,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: dividerColor, height: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Institute name ──
                _buildOutlinedField(
                  controller: controller.instituteNameController,
                  label: 'School or college'.tr,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Educational Workplace name is required!';
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: Text('Required'.tr, style: TextStyle(fontSize: 12, color: textSecondary)),
                ),

                // ── Currently studying ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Currently studying here'.tr,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
                      ),
                    ),
                    Obx(() => Checkbox(
                          value: controller.isStudying.value,
                          onChanged: (v) {
                            if (v != null) controller.getIsStudyingCurrently(v);
                          },
                          activeColor: PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        )),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Start date ──
                Text('Start date'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                const SizedBox(height: 8),
                _buildDatePickerRow(
                  context: context,
                  dateValue: controller.startDate,
                  inputBg: inputBg,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  dateController: controller.startDateController,
                ),
                const SizedBox(height: 20),

                // ── End date ──
                Text('End date'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                const SizedBox(height: 8),
                Obx(() => Opacity(
                      opacity: controller.isStudying.value ? 0.4 : 1.0,
                      child: IgnorePointer(
                        ignoring: controller.isStudying.value,
                        child: _buildDatePickerRow(
                          context: context,
                          dateValue: controller.endDate,
                          inputBg: inputBg,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          firstDate: controller.startDate.value != null && controller.startDate.value!.isNotEmpty
                              ? DateTime.tryParse(controller.startDate.value!) ?? DateTime(1950)
                              : DateTime(1950),
                          lastDate: DateTime.now(),
                          dateController: controller.endDateController,
                        ),
                      ),
                    )),
                const SizedBox(height: 24),

                // ── Remove button ──
                if (controller.isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        try {
                          final aboutCtrl = Get.find<dynamic>();
                          aboutCtrl.onTapDeleteInstitutePost(controller.educationalWorkPlaceModel?.id ?? '');
                          Get.back();
                        } catch (_) {}
                      },
                      icon: Icon(Icons.delete_outline, size: 18, color: textPrimary),
                      label: Text('Remove'.tr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inputBg,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),

                if (controller.isEditing) const SizedBox(height: 24),

                // ── Who can see this? ──
                _buildPrivacyRow(
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  privacy: controller.privacyModel?.privacy,
                ),

                const SizedBox(height: 16),

                // ── Save button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.formKey.currentState!.validate() &&
                          controller.startDate.value != null &&
                          (controller.endDate.value != null || controller.isStudying.value)) {
                        controller.isEditing
                            ? controller.onTapEditEducationPatch(id: controller.educationalWorkPlaceModel?.id)
                            : controller.onTapAddEducationPost();
                      } else {
                        controller.formKey.currentState!.validate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Save'.tr,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedField({
    TextEditingController? controller,
    required String label,
    required Color textPrimary,
    required Color textSecondary,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 15, color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14, color: textSecondary),
        floatingLabelStyle: TextStyle(fontSize: 12, color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PRIMARY_COLOR),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDatePickerRow({
    required BuildContext context,
    required Rx<String?> dateValue,
    required Color inputBg,
    required Color textPrimary,
    required Color textSecondary,
    required DateTime firstDate,
    required DateTime lastDate,
    required TextEditingController dateController,
  }) {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
        ).then((value) {
          if (value != null) {
            dateValue.value =
                '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
            dateController.text = dateValue.value!.toFormatDateOfBirth();
          }
        });
      },
      child: Obx(() {
        DateTime? parsed;
        if (dateValue.value != null && dateValue.value!.isNotEmpty) {
          parsed = DateTime.tryParse(dateValue.value!);
        }
        return Row(
          children: [
            _datePill(parsed != null ? '${parsed.year}' : 'Year'.tr, inputBg, textPrimary, textSecondary),
            const SizedBox(width: 8),
            _datePill(parsed != null ? _monthName(parsed.month) : 'Month'.tr, inputBg, textPrimary, textSecondary),
            const SizedBox(width: 8),
            _datePill(parsed != null ? '${parsed.day}' : 'Day'.tr, inputBg, textPrimary, textSecondary),
          ],
        );
      }),
    );
  }

  Widget _datePill(String text, Color bg, Color textColor, Color hintColor) {
    final hasValue = text != 'Year' && text != 'Month' && text != 'Day';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: hasValue ? textColor : hintColor)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 18, color: hasValue ? textColor : hintColor),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  Widget _buildPrivacyRow({
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    String? privacy,
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
        Row(
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
        const SizedBox(height: 16),
        Divider(height: 0.5, color: dividerColor),
      ],
    );
  }
}
