import 'package:flutter/material.dart';

import '../../../controller/const/colors.dart';

class PrivacyPolicyEn extends StatelessWidget {
  const PrivacyPolicyEn({super.key});

  Text buildTitle(String text,context) => Text(
    text,
    style:  TextStyle(
      color: AppColors.blackColor(context),
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 2,
    ),
  );

  Text buildParagraph(String text,context) => Text(
    text,
    style:  TextStyle(
      color: AppColors.blackColor(context),
      fontSize: 15,
      height: 1.6,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildParagraph(
            'Welcome to Qars Spin. Protecting your privacy, we handle your personal information with care. '
                'This privacy policy describes how we collect, share, and use information when you visit or make a purchase from our website or mobile app.',context
        ),

        const SizedBox(height: 20),
        buildTitle('1. Information We Collect',context),
        buildParagraph(
            'You are regularly communicating with others using the messenger, which includes sending various types of data that we collect to provide better Services.\n\n'
                'Personal Information: As you use our Services, we may collect personal details such as your name, email address, phone number, or other contact details, billing and shipping addresses, payment card details, purchase history, browsing activity, IP address, device identifiers, and preferences.\n\n'
                'Vehicle Information: If you are buying a car using our Services, we may collect information about the vehicle, such as its make, model year and VIN.\n\n'
                'Usage Information: We record information about your use of our Services, including browsing history, search queries, and pages viewed.\n\n'
                'Location Data: We may collect your location to show geographically relevant content, nearby inspection centers, or related services.\n\n'
                'Device Information: We may collect information about the device you use when accessing our Services, including network type, hardware, operating system, and unique identifiers.',context
        ),

        const SizedBox(height: 20),
        buildTitle('2. How We Use Your Information',context),
        buildParagraph(
            'We use the information we collect for the following purposes:\n\n'
                '• Service Delivery: To provide, operate, and maintain our Services, including facilitating car transactions, inspections, registrations, and payment processing.\n\n'
                '• Customer Support: To respond to your inquiries, provide support, and resolve issues related to our Services.\n\n'
                '• Personalization: To tailor your experience, such as suggesting vehicles or services based on your preferences and previous interactions.\n\n'
                '• Marketing and Promotions: To send you offers, newsletters, and marketing communications that may interest you. You can opt-out at any time.\n\n'
                '• Security and Fraud Prevention: To protect users and systems from fraudulent or illegal activities.\n\n'
                '• Legal Compliance: To comply with legal obligations, resolve disputes, and enforce agreements.',context
        ),

        const SizedBox(height: 20),
        buildTitle('3. Sharing Your Information',context),
        buildParagraph(
            'We may share your information with the following parties:\n\n'
                '• Service Providers: Third-party providers who help us operate our Services, such as payment processors, inspection centers, and marketing agencies.\n\n'
                '• Business Partners: Partners who offer additional products or services that may interest you.\n\n'
                '• Legal Authorities: We may disclose your data when required by law or legal process.\n\n'
                '• Corporate Transactions: If Qars Spin undergoes a merger, acquisition, or sale, your data may be transferred as part of that transaction.',context
        ),

        const SizedBox(height: 20),
        buildTitle('4. Your Choices and Rights',context),
        buildParagraph(
            'You have the following rights regarding your information:\n\n'
                '• Access and Correction: You can update your personal information via your account settings or by contacting us.\n\n'
                '• Deletion: You may request deletion of your personal data, subject to legal obligations.\n\n'
                '• Opt-Out: You can stop receiving marketing messages by following unsubscribe links.\n\n'
                '• Cookies: Manage cookie preferences through browser settings or our Cookie Policy.',context
        ),

        const SizedBox(height: 20),
        buildTitle('5. Security',context),
        buildParagraph(
            'We implement various measures to protect your data from unauthorized access or misuse. However, no online transmission or storage method is 100% secure, and we cannot guarantee absolute security.',context
        ),

        const SizedBox(height: 20),
        buildTitle('6. Children\'s Privacy',context),
        buildParagraph(
            'Our Services are not directed at individuals under 18. We do not knowingly collect personal information from minors. If such data is found, we delete it immediately.',context
        ),

        const SizedBox(height: 20),
        buildTitle('7. International Data Transfers',context),
        buildParagraph(
            'Your information may be stored or processed in other countries with different data protection laws. By using our Services, you consent to such transfers.',context
        ),

        const SizedBox(height: 20),
        buildTitle('8. Changes to This Privacy Policy',context),
        buildParagraph(
            'We may update this Privacy Policy occasionally. Changes will be posted on our website and mobile app. Please review periodically for updates.',context
        ),

        const SizedBox(height: 20),
        buildTitle('9. Contact Us',context),
        buildParagraph(
            'If you have any questions about this Privacy Policy or our practices, contact us:\n\n'
                'Qars Spin\n'
                'Email: Qarsspin@gmail.com\n'
                'Phone: +974-66288388\n'
                'Website: www.QarsSpin.com\n\n'
                'This privacy policy ensures that Qars Spin is transparent about how user data is handled, providing peace of mind to customers while complying with legal requirements.',context
        ),
      ],
    );
  }
}
