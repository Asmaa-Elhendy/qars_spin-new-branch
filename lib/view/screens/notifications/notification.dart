import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/notification_model.dart';
import '../../widgets/notification_card.dart';


class NotificationsPage extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: "Qars Spin Update for Post 6G4TNR",
      postKind: "Car for Sale",
      postCode: "6G4TNR",
      status: "Rejected",
      reason:
      "الرجاء إضافة صور حقيقية للسيارة\nإضافة 4 صور على الأقل\nنشر الاعلان ثم طلب تصوير 360",
      date: "20/09/2025 13:39",
    ),
    NotificationModel(
      title: "Qars Spin Update for Post 3H7PLQ",
      postKind: "Car for Rent",
      postCode: "3H7PLQ",
      status: "Approved",
      reason: "تمت الموافقة على الإعلان.",
      date: "22/09/2025 09:22",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
        },
      ),
    );
  }
}

