import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/constants/api_constant.dart';
import '../data/login_creadential.dart';
import '../models/api_response.dart';
import '../services/api_communication.dart';

class SessionTracker with WidgetsBindingObserver {
  static final SessionTracker _instance = SessionTracker._internal();
  factory SessionTracker() => _instance;
  SessionTracker._internal();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _periodicTimer;
  bool _isInitialized = false;

  final Duration periodicInterval = const Duration(minutes: 5);
  static const String _persistKeyMillis = 'session_active_milliseconds';

  late final ApiCommunication _apiCommunication;

  Future<void> init({required ApiCommunication apiCommunication}) async {
    if (_isInitialized) return;
    WidgetsBinding.instance.addObserver(this);
    _apiCommunication = apiCommunication;

    await _loadAndSendPersisted();
    _stopwatch.start();
    _startPeriodicSender();
    _isInitialized = true;
  }

  @override
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App has resumed (foreground)
      _stopwatch.start();
    } else if (state == AppLifecycleState.paused) {
      // App is paused (background)
      _stopwatch.stop();
      _sendToBackend(await _getTotalMilliseconds());
    } else if (state == AppLifecycleState.inactive) {
      // The app is inactive (before going into background or being terminated)
      _stopwatch.stop();
      _sendToBackend(await _getTotalMilliseconds());
    }
  }


  Future<int> _getTotalMilliseconds() async {
    final prefs = await SharedPreferences.getInstance();
    final persisted = prefs.getInt(_persistKeyMillis) ?? 0;
    return persisted + _stopwatch.elapsed.inMilliseconds;
  }

  Future<void> _persistAndSend() async {
    final prefs = await SharedPreferences.getInstance();
    final totalMs = await _getTotalMilliseconds();

    _stopwatch.reset();
    await prefs.setInt(_persistKeyMillis, totalMs);

    final success = await _sendToBackend(totalMs);
    if (success) {
      await prefs.setInt(_persistKeyMillis, 0);
    }
  }

  void _startPeriodicSender() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(periodicInterval, (timer) async {
      final totalMs = await _getTotalMilliseconds();
      if (totalMs > 0) {
        final success = await _sendToBackend(totalMs);
        if (success) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_persistKeyMillis, 0);
          _stopwatch.reset();
          _stopwatch.start();
        }
      }
    });
  }

  Future<bool> _sendToBackend(int milliseconds) async {
    if (milliseconds <= 0) return true;

    try {
      final token = LoginCredential().getAccessToken();

      final response = await http.post(
        Uri.parse('${ApiConstant.BASE_URL}profile/active-time'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'time': milliseconds}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendAndResetNow({Duration timeout = const Duration(seconds: 5)}) async {
    final totalMs = await _getTotalMilliseconds();
    if (totalMs <= 0) return true;

    try {
      final success = await _sendToBackend(totalMs).timeout(timeout);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_persistKeyMillis, 0);
        _stopwatch.reset();
        _stopwatch.start();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadAndSendPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final persisted = prefs.getInt(_persistKeyMillis) ?? 0;
    if (persisted > 0) {
      final success = await _sendToBackend(persisted);
      if (success) {
        await prefs.setInt(_persistKeyMillis, 0);
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _periodicTimer?.cancel();
  }
}
