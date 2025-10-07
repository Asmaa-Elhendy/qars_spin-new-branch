import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qarsspin/controller/const/colors.dart';

import '../../model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;

    double height=MediaQuery.of(context).size.height;
    return Container(
      margin:  EdgeInsets.symmetric(vertical: height*.01),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade500, // Border color
          width: 1,                    // Border width
        ),
        borderRadius: BorderRadius.circular(5),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade300,
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   )
        // ],
      ),
      padding:  EdgeInsets.symmetric(vertical: height*.01,horizontal: width*.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text("Your post status has changed:"),
          Text("Post Details:"),
          Text("Post Kind: ${notification.postKind}"),
          Text("Post Code: ${notification.postCode}"),
          Text(
            "New Status: ${notification.status}",
          ),
          const Text("Reason:"),
          Text(
            notification.reason,
            textDirection: TextDirection.rtl,
            style: const TextStyle(height: 1.4),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
                SvgPicture.asset(
                  'assets/images/calender.svg',
                width: width * .04,color: AppColors.gray,

              ),
              const SizedBox(width: 6),
              Text(
                notification.date,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
