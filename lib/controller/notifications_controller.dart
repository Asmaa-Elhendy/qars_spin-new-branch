import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';

import '../model/notification_model.dart';
import '../services/notification_database.dart';
import '../services/fcm_service.dart';
import 'ads/data_layer.dart'; // لو فعلاً مستخدمه

class NotificationsController extends GetxController {
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxBool _isLoading = false.obs;
  final NotificationDatabase _database = NotificationDatabase();
  final FCMService _fcmService = Get.find<FCMService>();

  List<NotificationModel> get notifications => _notifications.reversed.toList();
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _setupFCMListeners();
    getNotifications();

    // لما يفتح التطبيق من إشعار (terminated state)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  /// 🔹 جلب الإشعارات من API
  Future<void> getNotifications() async {
    try {
      _isLoading.value = true;
      log('📡 Fetching notifications for user: $userName');

      final List<NotificationModel> apiNotifications =
      await _database.fetchNotificationsFromAPI(
        userName: userName,
        ourSecret: ourSecret,
      );

      log('📩 Notifications received: ${apiNotifications.length}');
      _notifications.clear();
      _notifications.addAll(apiNotifications);

      if (apiNotifications.isEmpty) {
        log('⚠️ No notifications found.');
      } else {
        log('✅ Loaded ${_notifications.length} notifications into controller.');
      }
    } catch (e, s) {
      log('❌ Error loading notifications: $e');
      log('$s');
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 🔹 تهيئة مستمعي الـ FCM
  void _setupFCMListeners() {
    _fcmService.onMessageReceived.listen((message) async {
      try {
        final notification = NotificationModel.fromFCM(message);

        // أضف الإشعار الجديد مباشرة للقائمة
        _notifications.insert(0, notification);
        _notifications.refresh();

        // عرض Snackbar
        if (Get.isSnackbarOpen != true) {
          Get.snackbar(
            message.notification?.title ?? 'New Notification',
            message.notification?.body ?? '',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error handling new FCM notification: $e');
        }
      }
    });
  }

  /// 🔹 التعامل مع إشعار تم النقر عليه
  void _handleMessage(RemoteMessage message) {
    try {
      final notification = NotificationModel.fromFCM(message);
      _navigateBasedOnNotification(notification);
    } catch (e) {
      if (kDebugMode) {
        print('Error handling FCM message: $e');
      }
    }
  }

  /// 🔹 التنقل بناءً على الإشعار
  void _navigateBasedOnNotification(NotificationModel notification) {
    try {
      if (notification.postCode != null) {
        // مثال: فتح صفحة إعلان
        // Get.to(() => PostDetailsScreen(postId: notification.postCode!));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error navigating based on notification: $e');
      }
    }
  }

  /// 🔹 تحديث توكن الـ FCM
  Future<void> updateFCMToken() async {
    try {
      await _fcmService.updateFCMToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
    }
  }
}
