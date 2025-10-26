import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/notification_model.dart';
import 'dart:developer';

class NotificationDatabase {
  static final NotificationDatabase _instance = NotificationDatabase._internal();

  factory NotificationDatabase() => _instance;
  NotificationDatabase._internal();
//j
  Future<List<NotificationModel>> fetchNotificationsFromAPI({
    required String userName,
    required String ourSecret,
  }) async {
    try {
      final url = Uri.parse(
        'https://qarsspintest.smartvillageqatar.com/QarsSpinAPI/BrowsingRelatedApi.asmx/GetNotificationsListByUser',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'UserName': userName, 'Our_Secret': ourSecret},
      );

      log('🔹 Raw API response (${response.statusCode}): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['Code'] == 'OK' && jsonResponse['Data'] != null) {
          final List<dynamic> dataList = jsonResponse['Data'];

          final List<NotificationModel> notifications = dataList.map((item) {
            try {
              final date = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(item['Subscription_Date'], true)
                  .toLocal();

              return NotificationModel(
                title:
                    'Qars Spin Update for Post ${item['Notification_ID']}',
                postKind: '',
                postCode: item['Notification_ID'].toString(),
                status: '',
                reason: item['Remarks'] ?? '',
                summaryPL: item['Notification_Summary_PL'],
                summarySL: item['Notification_Summary_SL'],
                date: date,
                data: item,
              );
            } catch (e) {
              log('⚠️ Error parsing item: $e');
              return NotificationModel(
                title: 'Invalid Notification',
                postKind: '',
                postCode: '',
                status: '',
                reason: '',
                date: DateTime.now(),
                data: {},
              );
            }
          }).toList();

          log('✅ Parsed ${notifications.length} notifications from API.');
          return notifications;
        } else {
          log('⚠️ API returned invalid data structure.');
          return [];
        }
      } else {
        log('❌ HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e, s) {
      log('❌ Exception fetching notifications: $e');
      log('$s');
      return [];
    }
  }
}
