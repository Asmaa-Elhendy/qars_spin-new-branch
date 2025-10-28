import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../controller/const/colors.dart';
import '../../model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Get additional FCM data
    final channelId = notification.data?['dChannel_ID']?.toString();
    final language = notification.data?['dLanguage']?.toString();
    final messageId = notification.data?['messageId']?.toString();

    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        border: Border.all(
          color: AppColors.divider(context),
          width: 0.8.w,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            notification.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.w,
              color: AppColors.blackColor(context)
            ),
          ),

          const SizedBox(height: 4),

          // Show channel and language if available
          if (channelId != null || language != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  if (channelId != null) ...[
                    Text(
                      'Channel: $channelId',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (language != null) const SizedBox(width: 8),
                  ],
                  if (language != null)
                    Text(
                      'Language: $language',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],


          // Post details
          if (notification.postKind != null || notification.postCode != null) ...[
            // if (notification.postKind != null)
            //   Text('Post Kind: ${notification.postKind}'),
            if (notification.postCode != null)
              Text('Post Code: ${notification.id}',style: TextStyle(fontSize: 15.w),),
            const SizedBox(height: 4),
          ],

          // Status and reason
          if (notification.summaryPL != null) ...[
            Text(
              notification.summaryPL!,
              style:  TextStyle(fontWeight: FontWeight.w500,fontSize: 15.w)
            ),
          ],
          if (notification.summarySL != null) ...[
            Text(
              notification.summarySL!,
              style:  TextStyle(fontWeight: FontWeight.w500,fontSize: 15.w),
            ),
          ],
          if (notification.reason?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              notification.reason!,
              style:  TextStyle(height: 1.4,fontSize: 15.w),
            ),
          ],

          // Date row
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/calender.svg',
                width: 16,
                color: AppColors.gray,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDate(notification.date,),
                style: TextStyle(color: Colors.grey.shade700,fontSize: 15.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMM d, y • h:mm a').format(date);
    } catch (e) {
      return date.toString();
    }
  }
}