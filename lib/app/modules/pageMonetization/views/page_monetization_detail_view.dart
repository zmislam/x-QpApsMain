import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../widgets/page_earning_overview.dart';
import '../widgets/page_tier_progress.dart';
import '../widgets/page_viral_history.dart';
import '../widgets/page_risk_indicator.dart';

/// Detail view for a single page's monetization (navigated from page profile)
class PageMonetizationDetailView extends GetView<PageMonetizationController> {
  const PageMonetizationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Obx(() {
          final pageId = controller.selectedPageId.value;
          final page = controller.pages
              .firstWhereOrNull((p) => p.pageId == pageId);
          return Text(page?.pageName ?? 'Page Monetization',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87));
        }),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;

        if (isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              PageEarningOverview(),
              SizedBox(height: 14),
              PageTierProgress(),
              SizedBox(height: 14),
              PageViralHistory(),
              SizedBox(height: 14),
              PageRiskIndicator(),
              SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
