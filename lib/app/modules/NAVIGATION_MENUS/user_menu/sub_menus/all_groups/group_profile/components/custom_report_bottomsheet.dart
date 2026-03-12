import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_profile_controller.dart';
import '../../../all_pages/pages/model/report_model.dart';
import '../../../../../../../config/constants/color.dart';

class CustomReportBottomSheet {
  static void showReportOptions({
    required BuildContext context,
    required List<PageReportModel> pageReportList,
    GroupProfileController? controller,
    required RxString selectedReportType,
    required RxString selectedReportId,
    required TextEditingController reportDescription,
    required Function(String, String, String, String) reportAction,
    required Function() onCancel,
  }) {
    Get.bottomSheet(
        backgroundColor: Colors.white,
        SizedBox(
          height: Get.height / 1.8,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SheetTitle(title: 'Report'.tr),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.clear, size: 20)),
                    ],
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  Expanded(
                    child: _ReportOptionsList(
                      pageReportList: pageReportList,
                      selectedReportType: selectedReportType,
                      selectedReportId: selectedReportId,
                    ),
                  ),
                  _BottomActions(
                    onCancel: onCancel,
                    onContinue: () {
                      Get.bottomSheet(
                          backgroundColor: Get.theme.cardTheme.color,
                          _CustomDescriptionBottomSheet(
                            reportDescription: reportDescription,
                            onCancel: onCancel,
                            onReport: () {
                              reportAction(
                                selectedReportId.value.toString(),
                                selectedReportType.value,
                                controller?.allGroupModel.value?.id ?? '',
                                reportDescription.text,
                              );
                            },
                          ),
                          // backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))));
  }
}

class _SheetTitle extends StatelessWidget {
  final String title;

  const _SheetTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ReportOptionsList extends StatelessWidget {
  final List<PageReportModel> pageReportList;
  final RxString selectedReportType;
  final RxString selectedReportId;

  const _ReportOptionsList({
    required this.pageReportList,
    required this.selectedReportType,
    required this.selectedReportId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: pageReportList.length,
      itemBuilder: (context, index) {
        Rx<PageReportModel> pageReportModel = pageReportList[index].obs;
        return Obx(
          () => ListTile(
            onTap: () {
              // Select the radio button on tap
              selectedReportType.value = pageReportModel.value.reportType ?? '';
              selectedReportId.value = pageReportModel.value.id ?? '';
              debugPrint('Selected Report Type: ${selectedReportType.value}');
            },
            title: Text(pageReportModel.value.reportType ?? ''),
            subtitle: Text(pageReportModel.value.description ?? ''),
            leading: Radio<String>(
              value: pageReportModel.value.reportType ?? '',
              groupValue: selectedReportType.value,
              toggleable: true,
              onChanged: (String? value) {
                if (value != null) {
                  selectedReportType.value = value;
                  selectedReportId.value = pageReportModel.value.id ?? '';
                  debugPrint('Selected Report Type: $value');
                }
              },
              activeColor: PRIMARY_COLOR,
            ),
          ),
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  final Function onCancel;
  final Function onContinue;

  const _BottomActions({
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Cancel'.tr,
            onPressed: onCancel,
            backgroundColor: Colors.white,
            borderColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: 'Continue'.tr,
            onPressed: onContinue,
            backgroundColor: PRIMARY_COLOR,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: Get.width / 2,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}

class _CustomDescriptionBottomSheet extends StatelessWidget {
  final TextEditingController reportDescription;
  final Function onCancel;
  final Function onReport;

  const _CustomDescriptionBottomSheet({
    required this.reportDescription,
    required this.onCancel,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 1.8,
      width: Get.width,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SheetTitle(title: 'Report'.tr),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.clear, size: 20)),
              ],
            ),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reportDescription,
                  maxLines: 8,
                  decoration: InputDecoration(
                      hintText: 'Enter a description about your Report...'.tr,
                      hintStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                      border: Theme.of(context).inputDecorationTheme.border,
                      enabledBorder:
                          Theme.of(context).inputDecorationTheme.enabledBorder,
                      focusedBorder:
                          Theme.of(context).inputDecorationTheme.focusedBorder),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Back'.tr,
                    onPressed: onCancel,
                    backgroundColor: Colors.white,
                    borderColor: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    label: 'Report'.tr,
                    onPressed: onReport,
                    backgroundColor: PRIMARY_COLOR,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
