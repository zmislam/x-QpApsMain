import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/tipping_controller.dart';
import '../widgets/tip_summary_card.dart';
import '../widgets/tip_history.dart';
import '../widgets/top_supporters.dart';
import '../widgets/tip_goal_progress.dart';
import '../widgets/tip_goal_form.dart';

class TipDashboardView extends GetView<TippingController> {
  const TipDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          title: const Text('Tips & Donations',
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
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            indicatorColor: PRIMARY_COLOR,
            labelStyle:
                TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 13),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
              Tab(text: 'Supporters'),
              Tab(text: 'Goal'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: PRIMARY_COLOR));
          }

          return TabBarView(
            children: [
              _overviewTab(),
              _receivedTab(),
              _sentTab(),
              _supportersTab(),
              _goalTab(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _overviewTab() {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshData(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (controller.summary.value != null)
            TipSummaryCard(summary: controller.summary.value!),
          if (controller.goals.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Active Goal',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TipGoalProgress(goal: controller.goals.first),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _receivedTab() {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshData(),
      child: TipHistory(
        transactions: controller.receivedHistory,
        type: 'received',
      ),
    );
  }

  Widget _sentTab() {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshData(),
      child: TipHistory(
        transactions: controller.sentHistory,
        type: 'sent',
      ),
    );
  }

  Widget _supportersTab() {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshData(),
      child: TopSupporters(supporters: controller.supporters),
    );
  }

  Widget _goalTab(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshData(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (controller.goals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined,
                        size: 40, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    Text('No active goals',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => TipGoalForm.show(context),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Create Goal',
                          style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ...controller.goals.map((goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TipGoalProgress(goal: goal),
                )),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () => TipGoalForm.show(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add New Goal',
                    style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
