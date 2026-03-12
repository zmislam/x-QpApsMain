import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../models/notification.dart';
import '../modules/NAVIGATION_MENUS/notification/controllers/notification_controller.dart';

// This MUST be a top-level function (outside of any class)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('Background notification tapped: ${notificationResponse.id}');
  debugPrint(
      'Background notification payload: ${notificationResponse.payload}');

  try {
    final notificationController = Get.find<NotificationController>();
    final payloadMap = jsonDecode(notificationResponse.payload ?? '{}')
        as Map<String, dynamic>;
    final notification = NotificationModel.fromMap(payloadMap);
    notificationController.handleNotificationTap(notification);
  } catch (e) {
    debugPrint('Error handling background notification: $e');
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  // Add this method
  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'quantum_possibilities_channel', // id
      'Quantum Possibilities', // title
      description: 'Notifications for Quantum Possibilities app',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> intialize() async {
    // Create the notification channel first
    await createNotificationChannel();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification tapped: ${response.id}');
        debugPrint('Notification tapped: ${response.actionId}');
        debugPrint('Notification tapped: ${response.input}');
        debugPrint('Notification tapped: ${response.notificationResponseType}');
        debugPrint('Notification tapped: ${response.payload}');

        try {
          final notificationController = Get.find<NotificationController>();
          final payloadMap =
              jsonDecode(response.payload ?? '{}') as Map<String, dynamic>;
          final notification = NotificationModel.fromMap(payloadMap);
          notificationController.handleNotificationTap(notification);
        } catch (e) {
          debugPrint('Error handling notification tap: $e');
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackground, // Use the top-level function
    );
    debugPrint('IS INIT DONE FOR NOTIFICATION : $initializationSettings');
  }

  // Update your displayNotification method
  static Future<void> displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'quantum_possibilities_channel', // Use the same channel ID
          'Quantum Possibilities',
          channelDescription: 'Notifications for Quantum Possibilities app',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
      );
      await _notificationPlugin.show(
        id,
        message.data['title'],
        message.data['body'],
        notificationDetails,
        payload: message.data['notification_model'].toString(),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
