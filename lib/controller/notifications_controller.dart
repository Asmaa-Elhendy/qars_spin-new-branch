import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../model/notification_model.dart';
import '../../services/notification_database.dart';
import '../../services/fcm_service.dart';


class NotificationsController extends GetxController {
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxBool _isLoading = false.obs;
  final NotificationDatabase _database = NotificationDatabase();
  final FCMService _fcmService = Get.find<FCMService>();

  List<NotificationModel> get notifications => _notifications.reversed.toList();
  bool get isLoading => _isLoading.value;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _setupFCMListeners();
    loadNotifications();
    
    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  Future<void> loadNotifications() async {
    _isLoading.value = true;
    try {
      final notifications = await _database.getNotifications();
      _notifications.assignAll(notifications);
      _notifications.refresh();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      _isLoading.value = false;
    }
  }

  void _setupFCMListeners() {
    // Listen for new FCM messages
    _fcmService.onMessageReceived.listen((message) async {
      try {
        final notification = NotificationModel.fromFCM(message);
        await _database.insertNotification(notification);
        await loadNotifications(); // Refresh the list
        
        // Show a snackbar for new notifications
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
          print('Error handling new notification: $e');
        }
      }
    });
  }

  Future<void> markAsRead(NotificationModel notification) async {
    try {
      final updated = notification.copyWith(isRead: true);
      await _database.updateNotification(updated);
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = updated;
        _notifications.refresh();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _database.markAllNotificationsAsRead();
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
      _notifications.refresh();
    } catch (e) {
      if (kDebugMode) {
        print('Error marking all as read: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    try {
      await _database.deleteNotification(notification.id!);
      _notifications.removeWhere((n) => n.id == notification.id);
      _notifications.refresh();
     // Get.snackbar('Success', 'Notification deleted');
    } catch (e) {
    //  Get.snackbar('Error', 'Failed to delete notification');
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      await _database.clearAllNotifications();
      _notifications.clear();
      _notifications.refresh();
     // Get.snackbar('Success', 'All notifications cleared');
    } catch (e) {
      //Get.snackbar('Error', 'Failed to clear notifications');
    }
  }

  void _handleMessage(RemoteMessage message) {
    try {
      final notification = NotificationModel.fromFCM(message);
      _navigateBasedOnNotification(notification);
    } catch (e) {
      if (kDebugMode) {
        print('Error handling message: $e');
      }
    }
  }

  void _navigateBasedOnNotification(NotificationModel notification) {
    try {
      // Example: Navigate based on postCode if available
      if (notification.postCode != null) {
        // Uncomment and implement your navigation logic
        // Get.to(() => PostDetailsScreen(postId: notification.postCode!));
      }
      
      // Mark as read when handled
      if (!notification.isRead) {
        markAsRead(notification);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in navigation: $e');
      }
    }
  }

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