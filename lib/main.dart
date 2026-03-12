import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import 'app/config/constants/stripe_config.dart';
import 'app/extension/dependency_injection.dart';
import 'app/services/api_communication.dart';
import 'app/services/local_notification_service.dart';
import 'app/utils/Localization/dynamicTransalationService.dart';
import 'app/utils/Localization/lib/app/modules/changeLanguage/controllers/languageController.dart';
import 'app/utils/loader.dart';
import 'app/utils/session_tracker.dart';
import 'firebase_options.dart';
import 'quantum_possibilities.dart';

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  // Handling the click event
  debugPrint('Notification tapped: ${notificationResponse.payload}');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await LocalNotificationService.displayNotification(message);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ========= Configure image cache for Facebook-grade performance =========
  // Increase in-memory image cache: 200 images, 100 MB max
  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024;

  final apiComm = ApiCommunication();
  // Initialize Language Controller
  Get.put(LanguageController());

  // Load translations BEFORE running app
  await DynamicTranslations.instance.loadLanguages();

  // Dependency Injection
  await DependencyInjection.init();
  // Initialize Flutter Stripe
  await StripeConfig.init();


  // Initialize Loader
  configLoader();

  // ========= initialize app in firebase ========
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ========= message handler function which is called when the app is in the background or terminated ========
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  LocalNotificationService.intialize();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ========= control whether FCM initializes itself automatically upon app startup =========
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onMessage.listen(
    (event) {
      debugPrint('NOTIFICATION EVENT');
      debugPrint('${event.data}');
      debugPrint(event.data['title']);
      debugPrint(event.data['body']);
      debugPrint(event.data['type']);
      debugPrint(event.data['notification_model']);
      LocalNotificationService.displayNotification(event);
    },
  );
  await SessionTracker().init(
    apiCommunication: apiComm,
  );

  // ========= Register memory pressure observer =========
  WidgetsBinding.instance.addObserver(_MemoryPressureObserver());

  runApp(
    const QuantumPossibilities(),
  );
}

/// Clears the in-memory image cache when the system signals low memory,
/// preventing OOM crashes on older devices while keeping disk cache intact.
class _MemoryPressureObserver extends WidgetsBindingObserver {
  @override
  void didHaveMemoryPressure() {
    debugPrint('[Performance] Memory pressure — clearing image cache');
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
