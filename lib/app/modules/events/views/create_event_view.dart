import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/color.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../controllers/create_event_controller.dart';

class CreateEventView extends GetView<CreateEventController> {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = FeedDesignTokens.cardBg(context);
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final inputBg = isDark ? Colors.white10 : Colors.grey.shade50;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldBg,
      // ─── Close button ────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textPrimary, size: 28),
          onPressed: () => Get.back(),
        ),
        title: null,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Cover image section ─────────────────────────
                  _buildCoverImageSection(
                      context, isDark, textPrimary, textSecondary),

                  const SizedBox(height: 16),

                  // ─── Form fields ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event name
                        _buildField(
                          controller: controller.titleController,
                          hint: 'Event name',
                          inputBg: inputBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                        ),
                        const SizedBox(height: 16),

                        // Start date and time
                        _buildDateField(
                          context: context,
                          label: 'Start date and time',
                          isDark: isDark,
                          inputBg: inputBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: 12),

                        // Quick action chips row
                        Obx(() => _buildChipsRow(
                            context, isDark, borderColor, textPrimary)),
                        const SizedBox(height: 16),

                        // End date (if toggled)
                        Obx(() {
                          if (!controller.showEndDate.value) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              _buildEndDateField(
                                context: context,
                                isDark: isDark,
                                inputBg: inputBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),

                        // Event mode
                        _buildDropdownField(
                          hint: 'Is it in person or virtual?',
                          items: controller.eventModes,
                          selectedKey: controller.eventMode,
                          inputBg: inputBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: 16),

                        // Venue (only if in_person or hybrid)
                        Obx(() {
                          if (controller.eventMode.value == 'virtual') {
                            return Column(
                              children: [
                                _buildField(
                                  controller: controller.meetingUrlController,
                                  hint: 'Meeting URL',
                                  inputBg: inputBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _buildField(
                                controller: controller.venueController,
                                hint: 'Venue name',
                                inputBg: inputBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: controller.cityController,
                                hint: 'City',
                                inputBg: inputBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),

                        // Privacy
                        _buildDropdownField(
                          hint: 'Who can see it?',
                          items: controller.privacyOptions,
                          selectedKey: controller.privacy,
                          inputBg: inputBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        _buildField(
                          controller: controller.descriptionController,
                          hint: 'What are the details?',
                          maxLines: 5,
                          inputBg: inputBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Create event button ─────────────────────────────────────
          _buildBottomButton(isDark, textPrimary),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  COVER IMAGE SECTION
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildCoverImageSection(BuildContext context, bool isDark,
      Color textPrimary, Color textSecondary) {
    return Stack(
      children: [
        // Cover image or placeholder
        Obx(() {
          if (controller.coverImagePath.value.isNotEmpty) {
            return SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.file(
                File(controller.coverImagePath.value),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _coverPlaceholder(isDark),
              ),
            );
          }
          return _coverPlaceholder(isDark);
        }),
        // Upload progress indicator
        Obx(() {
          if (controller.isUploadingCover.value) {
            return Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        // Remove button (when image is set)
        Obx(() {
          if (controller.coverImagePath.value.isNotEmpty) {
            return Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: controller.removeCoverImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        // Overlay buttons
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _coverActionButton(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                isDark: isDark,
                onTap: () => controller.pickFromGallery(),
              ),
              const SizedBox(height: 8),
              _coverActionButton(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                isDark: isDark,
                onTap: () => controller.pickFromCamera(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverPlaceholder(bool isDark) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [
                  const Color(0xFFB2E0D9),
                  const Color(0xFFE8C4C4),
                  const Color(0xFFF5D5C8),
                ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 56,
          color: isDark ? Colors.white38 : Colors.black26,
        ),
      ),
    );
  }

  Widget _coverActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TEXT FIELD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textPrimary.withOpacity(0.4), fontSize: 15),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PRIMARY_COLOR, width: 1.5),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DATE FIELD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required bool isDark,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return GestureDetector(
      onTap: () => controller.pickStartDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  controller.formattedStartDate,
                  style: TextStyle(
                    fontSize: 15,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDateField({
    required BuildContext context,
    required bool isDark,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return GestureDetector(
      onTap: () => controller.pickEndDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'End date and time',
              style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  controller.endDate.value != null
                      ? controller.endDate.value.toString().substring(0, 16)
                      : 'Tap to set end date',
                  style: TextStyle(
                    fontSize: 15,
                    color: controller.endDate.value != null
                        ? textPrimary
                        : textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CHIPS ROW (Add end time, Repeat event, UTC)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildChipsRow(
      BuildContext context, bool isDark, Color borderColor, Color textPrimary) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _actionChip(
          icon: Icons.access_time,
          label: 'Add end time',
          isDark: isDark,
          borderColor: borderColor,
          textPrimary: textPrimary,
          isActive: controller.showEndDate.value,
          onTap: controller.toggleEndDate,
        ),
        _actionChip(
          icon: Icons.repeat,
          label: 'Repeat event',
          isDark: isDark,
          borderColor: borderColor,
          textPrimary: textPrimary,
          isActive: controller.isRecurring.value,
          onTap: () {
            controller.isRecurring.value = !controller.isRecurring.value;
          },
        ),
        Obx(() => _actionChip(
              icon: Icons.language,
              label: controller.timezone.value,
              isDark: isDark,
              borderColor: borderColor,
              textPrimary: textPrimary,
              isActive: false,
              onTap: () {
                // Timezone picker
              },
            )),
      ],
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color borderColor,
    required Color textPrimary,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? PRIMARY_COLOR.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? PRIMARY_COLOR : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isActive ? PRIMARY_COLOR : textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? PRIMARY_COLOR : textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DROPDOWN FIELD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildDropdownField({
    required String hint,
    required List<Map<String, String>> items,
    required RxString selectedKey,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Obx(() {
      final current = items.firstWhereOrNull(
          (i) => i['key'] == selectedKey.value);
      return GestureDetector(
        onTap: () {
          _showDropdownSheet(
            items: items,
            selectedKey: selectedKey,
            textPrimary: textPrimary,
          );
        },
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  current != null ? current['label']! : hint,
                  style: TextStyle(
                    fontSize: 15,
                    color: current != null
                        ? textPrimary
                        : textPrimary.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  color: textSecondary, size: 22),
            ],
          ),
        ),
      );
    });
  }

  void _showDropdownSheet({
    required List<Map<String, String>> items,
    required RxString selectedKey,
    required Color textPrimary,
  }) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) {
              final isSelected = item['key'] == selectedKey.value;
              return ListTile(
                title: Text(
                  item['label']!,
                  style: TextStyle(
                    color: isSelected ? PRIMARY_COLOR : textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle,
                        color: PRIMARY_COLOR, size: 22)
                    : null,
                onTap: () {
                  selectedKey.value = item['key']!;
                  Get.back();
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BOTTOM BUTTON
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildBottomButton(bool isDark, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border(
          top: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200),
        ),
      ),
      child: Obx(() {
        final submitting = controller.isSubmitting.value;
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: submitting ? null : controller.createEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  submitting ? Colors.grey.shade400 : PRIMARY_COLOR,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Create event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
