import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckerService {
  static final VersionCheckerService _instance = VersionCheckerService._internal();
  factory VersionCheckerService() => _instance;
  VersionCheckerService._internal();

  bool _hasCheckedVersion = false;
  static const String _androidId = 'com.quanumpossibilities.qp';
  static const String _iOSId = 'com.quanumpossibilities.qp';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidId';

  /// Check app version and show force update dialog if needed
  Future<void> checkAppVersion({bool forceCheck = false}) async {
    if (_hasCheckedVersion && !forceCheck) return;
    _hasCheckedVersion = true;

    // Add delay to ensure navigation and network are ready
    await Future.delayed(const Duration(seconds: 1));

    try {
      debugPrint('🔍 Starting version check...');

      // Check internet connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('❌ No internet connection');
        return;
      }

      final newVersion = NewVersionPlus(
        androidId: _androidId,
        iOSId: _iOSId,
        iOSAppStoreCountry: 'us',
      );

      final status = await newVersion.getVersionStatus();

      debugPrint('📱 Local version: ${status?.localVersion}');
      debugPrint('🏪 Store version: ${status?.storeVersion}');
      debugPrint('✅ Can update: ${status?.canUpdate}');

      if (status != null && status.canUpdate) {
        debugPrint('🚀 Showing force update dialog');
        _showForceUpdateDialog(status, newVersion);
      } else {
        debugPrint('✨ App is up to date or no update needed');
      }
    } on SocketException catch (e) {
      debugPrint('❌ Network error: $e');
      // Retry once after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      _hasCheckedVersion = false;
      checkAppVersion(forceCheck: forceCheck);
    } catch (e, stackTrace) {
      debugPrint('❌ Version check failed: $e');
      debugPrint('Stack trace: $stackTrace');

      // Try alternative method using direct HTTP request
      await _checkVersionManually();
    }
  }

  /// Fallback method: Check version manually via HTTP
  Future<void> _checkVersionManually() async {
    try {
      debugPrint('🔄 Trying manual version check...');

      final dio = Dio();

      // Try to fetch Play Store page
      final response = await dio.get(
        'https://play.google.com/store/apps/details',
        queryParameters: {'id': _androidId},
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final html = response.data.toString();

        // Extract version from HTML (Play Store shows it in meta tags)
        final versionMatch = RegExp(r'\[\[\["([\d.]+)"\]\]').firstMatch(html);

        if (versionMatch != null) {
          final storeVersion = versionMatch.group(1);
          debugPrint('🏪 Store version (manual): $storeVersion');

          // Get local version
          final packageInfo = await PackageInfo.fromPlatform();
          final localVersion = packageInfo.version;

          debugPrint('📱 Local version: $localVersion');

          // Compare versions
          if (_shouldUpdate(localVersion, storeVersion ?? '')) {
            debugPrint('🚀 Update needed - showing dialog');
            _showSimpleUpdateDialog(storeVersion ?? '1.1.0');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Manual version check also failed: $e');
    }
  }

  /// Compare version numbers
  bool _shouldUpdate(String local, String store) {
    try {
      final localParts = local.split('.').map(int.parse).toList();
      final storeParts = store.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final localPart = i < localParts.length ? localParts[i] : 0;
        final storePart = i < storeParts.length ? storeParts[i] : 0;

        if (storePart > localPart) return true;
        if (localPart > storePart) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Show force update dialog (when using NewVersionPlus)
  void _showForceUpdateDialog(VersionStatus status, NewVersionPlus newVersion) {
    final context = Get.overlayContext;
    if (context == null || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Update Required'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'A new version (${status.storeVersion}) is available.\n\n'
                  'Current version: ${status.localVersion}\n\n'
                  'Please update the app for the best performance to continue using the app.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    debugPrint('🔗 Launching store: ${status.appStoreLink}');
                    newVersion.launchAppStore(status.appStoreLink);
                  },
                  child: Text('Update Now'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show simple update dialog (fallback method)
  void _showSimpleUpdateDialog(String storeVersion) {
    final context = Get.overlayContext;
    if (context == null || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Update Required'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'A new version ($storeVersion) is available.\n\n'
                  'Please update to continue using the app.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(_playStoreUrl))) {
                      await launchUrl(
                        Uri.parse(_playStoreUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text('Update Now'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Reset the check flag (useful for testing)
  void resetCheck() {
    _hasCheckedVersion = false;
  }
}