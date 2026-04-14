import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/reels_v2_main_controller.dart';
import '../utils/reel_enums.dart';
import 'reels_feed_view.dart';

/// Main Reels V2 View — Full-screen with tabbed feeds.
class ReelsV2View extends GetView<ReelsV2MainController> {
  const ReelsV2View({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Feed content
            Obx(() {
              if (!controller.isInitialized.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.isError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white54, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value.isNotEmpty
                            ? controller.errorMessage.value
                            : 'Something went wrong',
                        style: const TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => controller.refreshFeed(),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }

              return TabBarView(
                controller: controller.tabController,
                children: controller.feedTabs.map((type) {
                  return ReelsFeedView(feedType: type);
                }).toList(),
              );
            }),

            // Top bar with tabs
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Tab bar
                          Expanded(
                            child: _buildTabBar(),
                          ),
                          // Camera button
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to camera (Phase 3)
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: controller.tabController,
      onTap: controller.onTabTapped,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: 'For You'),
        Tab(text: 'Following'),
        Tab(text: 'Trending'),
      ],
    );
  }
}
