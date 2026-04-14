import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../models/page_monetization_models.dart';
import '../widgets/page_eligibility_card.dart';
import '../widgets/page_application_form.dart';
import '../widgets/page_application_status.dart';
import '../widgets/page_earning_overview.dart';
import '../widgets/page_tier_progress.dart';
import '../widgets/page_viral_history.dart';
import '../widgets/page_risk_indicator.dart';

class PageMonetizationView extends GetView<PageMonetizationController> {
  const PageMonetizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text('Page Monetization',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final pages = controller.pages;

        if (isLoading && pages.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: PRIMARY_COLOR));
        }

        if (pages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pages_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No pages found',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Text('Create a page to get started with monetization',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: PRIMARY_COLOR,
          onRefresh: () => controller.refreshData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Page selector
              _pageSelector(pages),
              const SizedBox(height: 14),

              // Content based on status
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: PRIMARY_COLOR)),
                )
              else
                _contentForStatus(),
            ],
          ),
        );
      }),
    );
  }

  Widget _pageSelector(List<PageMonetizationSummary> pages) {
    return Obx(() {
      final selectedId = controller.selectedPageId.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: pages.any((p) => p.pageId == selectedId)
                ? selectedId
                : null,
            isExpanded: true,
            hint: const Text('Select a page'),
            items: pages.map((p) {
              return DropdownMenuItem(
                value: p.pageId,
                child: Row(
                  children: [
                    // Status dot
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.statusColor,
                      ),
                    ),
                    Expanded(
                      child: Text(p.pageName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (p.tierName != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(p.tierName!,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500)),
                      ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (id) {
              if (id != null) controller.selectPage(id);
            },
          ),
        ),
      );
    });
  }

  Widget _contentForStatus() {
    return Obx(() {
      final status =
          controller.monetizationStatus.value?.status ?? 'not_applied';
      final risk = controller.riskProfile.value;

      switch (status) {
        case 'not_applied':
        case 'rejected':
          return Column(
            children: [
              const PageEligibilityCard(),
              const SizedBox(height: 14),
              const PageApplicationForm(),
              if (status == 'rejected') ...[
                const SizedBox(height: 14),
                const PageApplicationStatus(),
              ],
            ],
          );

        case 'pending':
        case 'under_review':
          return const PageApplicationStatus();

        case 'approved':
        case 'active':
          return Column(
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
          );

        case 'suspended':
          return Column(
            children: [
              // Warning banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This page\'s monetization has been suspended.',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const PageRiskIndicator(),
            ],
          );

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
