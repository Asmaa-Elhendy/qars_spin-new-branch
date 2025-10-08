import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class FCMService extends GetxService {
  static FCMService get to => Get.find();
  
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final String _fcmTokenKey = 'firebase_Token';
  
  // Stream to handle incoming messages
  final _messageStreamController = StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get onMessageReceived => _messageStreamController.stream;
  
  Future<void> initialize() async {
    try {
      // Request permissions
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('Notification settings: ${settings.authorizationStatus}');
      }
      
      // Get FCM token
      await _getFCMToken();
      
      // Listen for messages
      _setupMessageHandlers();
      
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM: $e');
      }
    }
  }
  
  void _setupMessageHandlers() {
    // Handle when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message received in foreground: ${message.messageId}');
      }
      _messageStreamController.add(message);
    });

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // Handle when app is in background but opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling message: ${message.messageId}');
      print('Message data: ${message.data}');
    }
    
    // Here you can handle navigation based on message data
    // Example: Get.toNamed('/notifications', arguments: message.data);
  }
  
  Future<void> _getFCMToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_fcmTokenKey, token);
        if (kDebugMode) {
          print('FCM Token: $token');
        }
        // TODO: Send token to your server
        // await _sendTokenToServer(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }
  
  // Call this when user logs in or language changes
  Future<void> updateFCMToken({String? newToken, String? language}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? oldToken = prefs.getString(_fcmTokenKey);
      
      newToken ??= await _fcm.getToken();
      
      if (newToken != null && newToken != oldToken) {
        await prefs.setString(_fcmTokenKey, newToken);
        // TODO: Call your API to update the token
        // Example: await ApiService.updateFCMToken(oldToken, newToken, language);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
    }
  }
  
  // Get current FCM token
  Future<String?> getCurrentToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current FCM token: $e');
      }
      return null;
    }
  }
  
  @override
  void onClose() {
    _messageStreamController.close();
    super.onClose();
  }
}
