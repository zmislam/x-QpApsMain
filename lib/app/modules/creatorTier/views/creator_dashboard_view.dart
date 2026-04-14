import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/creator_tier_controller.dart';
import '../widgets/creator_tier_badge.dart';
import '../widgets/tier_progress_card.dart';
import '../widgets/eligibility_card.dart';
import '../widgets/application_form.dart';
import '../widgets/application_status.dart';
import '../widgets/priority_score_breakdown.dart';
import '../widgets/tier_history_card.dart';

class CreatorDashboardView extends GetView<CreatorTierController> {
  const CreatorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text('Creator Dashboard',
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
        if (!controller.tierEnabled) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events_outlined,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('Creator tiers are not available',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            ),
          );
        }

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
            children: [
              _contentForStatus(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _contentForStatus() {
    return Obx(() {
      final appStatus = controller.application.value?.status ?? 'not_applied';

      switch (appStatus) {
        case 'not_applied':
        case 'rejected':
          return Column(
            children: [
              const EligibilityCard(),
              const SizedBox(height: 14),
              const ApplicationForm(),
              if (appStatus == 'rejected') ...[
                const SizedBox(height: 14),
                const ApplicationStatus(),
              ],
            ],
          );

        case 'pending':
          return const ApplicationStatus();

        case 'approved':
          return Column(
            children: const [
              TierProgressCard(),
              SizedBox(height: 14),
              PriorityScoreBreakdownWidget(),
              SizedBox(height: 14),
              TierHistoryCard(),
            ],
          );

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
