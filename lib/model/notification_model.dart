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
  final String? summaryPL;
  final String? summarySL;
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
    this.summaryPL,
    this.summarySL,
    required this.date,
    this.isRead = false,
    this.data,
  });

  /// 🔹 إنشاء إشعار من Firebase Cloud Messaging
  factory NotificationModel.fromFCM(RemoteMessage message) {
    try {
      final data = message.data;
      final notification = message.notification;

      final title = data['dTitle'] ?? notification?.title ?? 'New Notification';
      final body = data['dBody'] ?? notification?.body ?? '';
      final postKind = data['postKind'];
      final postCode = data['postCode'];
      final status = data['status'];
      final summaryPL = data['summaryPL'];
      final summarySL = data['summarySL'];

      // دمج كل البيانات اللي جاية من FCM في خريطة واحدة
      final notificationData = {
        ...data,
        'title': title,
        'body': body,
        'messageId': message.messageId,
      };

      return NotificationModel(
        title: title,
        postKind: postKind,
        postCode: postCode,
        status: status,
        reason: body,
        summaryPL: summaryPL,
        summarySL: summarySL,
        date: DateTime.now().toUtc(),
        data: notificationData,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parsing FCM notification: $e');
      }
      return NotificationModel(
        title: 'New Notification',
        date: DateTime.now().toUtc(),
        data: {'error': e.toString()},
      );
    }
  }

  /// 🔹 إنشاء إشعار من خريطة بيانات (API)
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    DateTime date;
    try {
      date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['date']).toUtc();
    } catch (_) {
      date = DateTime.now().toUtc();
    }

    Map<String, dynamic>? data;
    if (map['data'] != null) {
      try {
        if (map['data'] is String) {
          data = Map<String, dynamic>.from(jsonDecode(map['data']));
        } else if (map['data'] is Map) {
          data = Map<String, dynamic>.from(map['data']);
        }
      } catch (_) {
        data = {'raw': map['data'].toString()};
      }
    }

    return NotificationModel(
      id: map['id'],
      title: map['title'] ?? 'No Title',
      postKind: map['postKind'],
      postCode: map['postCode'],
      status: map['status'],
      reason: map['reason'],
      summaryPL: map['summaryPL'],
      summarySL: map['summarySL'],
      date: date,
      isRead: map['isRead'] == 1 || map['isRead'] == true,
      data: data,
    );
  }

  /// 🔹 تحويل الكائن إلى خريطة (للتخزين أو الإرسال)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'postKind': postKind,
      'postCode': postCode,
      'status': status,
      'reason': reason,
      'summaryPL': summaryPL,
      'summarySL': summarySL,
      'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date.toLocal()),
      'isRead': isRead ? 1 : 0,
      'data': jsonEncode(data ?? {}),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? postKind,
    String? postCode,
    String? status,
    String? reason,
    String? summaryPL,
    String? summarySL,
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
      summaryPL: summaryPL ?? this.summaryPL,
      summarySL: summarySL ?? this.summarySL,
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
              summaryPL == other.summaryPL &&
              summarySL == other.summarySL &&
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
      summaryPL.hashCode ^
      summarySL.hashCode ^
      date.hashCode ^
      isRead.hashCode ^
      data.hashCode;
}