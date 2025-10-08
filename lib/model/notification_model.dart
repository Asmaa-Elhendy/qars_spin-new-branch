import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class NotificationModel {
  final int? id;
  final String title;
  final String? postKind;
  final String? postCode;
  final String? status;
  final String? reason;
  final DateTime date;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationModel({
    this.id,
    required this.title,
    this.postKind,
    this.postCode,
    this.status,
    this.reason,
    required this.date,
    this.isRead = false,
    this.data,
  });

  factory NotificationModel.fromFCM(RemoteMessage message) {
    try {
      final data = message.data;
      final notification = message.notification;
      
      // Map the new FCM fields to our model
      final title = data['dTitle'] ?? notification?.title ?? 'New Notification';
      final body = data['dBody'] ?? notification?.body ?? '';
      final postKind = data['postKind'];
      final postCode = data['postCode'];
      final status = data['status'];
      final channelId = data['dChannel_ID'];
      final language = data['dLanguage'];
      final messageId = data['messageId'];

      // Include all data in the data map
      final notificationData = {
        ...data,
        'dChannel_ID': channelId,
        'dLanguage': language,
        'messageId': messageId,
      };

      return NotificationModel(
        title: title,
        postKind: postKind,
        postCode: postCode,
        status: status,
        reason: body, // Using dBody as reason
        date: DateTime.now().toUtc(),
        isRead: false,
        data: notificationData,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error creating notification from FCM: $e');
      }
      return NotificationModel(
        title: 'New Notification',
        date: DateTime.now().toUtc(),
        data: {'error': 'Failed to parse notification data: $e'},
      );
    }
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      DateTime date;
      try {
        date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['date']).toUtc();
      } catch (e) {
        date = DateTime.now().toUtc();
      }

      Map<String, dynamic>? data;
      if (map['data'] != null) {
        if (map['data'] is String) {
          try {
            data = Map<String, dynamic>.from(
              Map.castFrom<dynamic, dynamic, String, dynamic>(
                const JsonDecoder().convert(map['data'])
              )
            );
          } catch (e) {
            data = {'raw_data': map['data'].toString()};
          }
        } else if (map['data'] is Map) {
          data = Map<String, dynamic>.from(map['data']);
        }
      }
//f
      return NotificationModel(
        id: map['id'],
        title: map['title'] ?? 'No Title',
        postKind: map['postKind'],
        postCode: map['postCode']?.toString(),
        status: map['status']?.toString(),
        reason: map['reason']?.toString(),
        date: date,
        isRead: map['isRead'] == 1 || map['isRead'] == true,
        data: data,
      );
    } catch (e) {
      return NotificationModel(
        title: 'Invalid Notification',
        date: DateTime.now().toUtc(),
        data: {'error': 'Failed to parse notification data'},
      );
    }
  }

  Map<String, dynamic> toMap() {
    try {
      return {
        if (id != null) 'id': id,
        'title': title,
        'postKind': postKind,
        'postCode': postCode,
        'status': status,
        'reason': reason,
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date.toLocal()),
        'isRead': isRead ? 1 : 0,
        'data': data?.toString(),
      };
    } catch (e) {
      return {
        'title': title,
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toLocal()),
        'isRead': isRead ? 1 : 0,
      };
    }
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? postKind,
    String? postCode,
    String? status,
    String? reason,
    DateTime? date,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      postKind: postKind ?? this.postKind,
      postCode: postCode ?? this.postCode,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          postKind == other.postKind &&
          postCode == other.postCode &&
          status == other.status &&
          reason == other.reason &&
          date == other.date &&
          isRead == other.isRead &&
          mapEquals(data, other.data);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      postKind.hashCode ^
      postCode.hashCode ^
      status.hashCode ^
      reason.hashCode ^
      date.hashCode ^
      isRead.hashCode ^
      data.hashCode;
}