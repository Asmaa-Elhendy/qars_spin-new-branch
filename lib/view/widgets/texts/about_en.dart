import 'package:flutter/material.dart';

class AboutEn extends StatelessWidget {
  const AboutEn({super.key});

  Text buildTitle(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 2,
    ),
  );

  Text buildParagraph(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 15,
      height: 1.6,
    ),
  );

  Widget buildBullet(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "• ",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildParagraph(
            'Welcome to Qars Spin, your ultimate destination for all your car needs. '
                'At Qars Spin, we understand that buying or selling a car can be a significant and sometimes daunting decision. '
                'That\'s why we are dedicated to providing a seamless, transparent, and comprehensive service that covers every aspect of the process. '
                'Our mission is to make your car ownership experience enjoyable and stress-free, whether you\'re purchasing a brand-new vehicle, '
                'selling a used one, or providing services for the one you already have.',
          ),

          const SizedBox(height: 20),
          buildTitle('Our Comprehensive Services'),
          buildBullet('Buying and Selling Cars'),
          buildBullet('Car Inspection'),
          buildBullet('Breakdown Service'),
          buildBullet('Car Registration'),
          buildBullet('Special Car Number Plate Service'),
          buildBullet('Secured Payment Service'),
          buildBullet('EMI Services'),

          const SizedBox(height: 20),
          buildTitle('Why Choose Qars Spin?'),
          buildBullet(
              'Customer-Centric Approach: Our customers are at the heart of everything we do. We are committed to delivering exceptional service, tailored to meet your specific needs.'),
          buildBullet(
              'Expertise and Experience: With years of experience in the automotive industry, our knowledgeable team is equipped to provide expert advice and support throughout your car buying or selling journey.'),
          buildBullet(
              'Quality and Trust: We uphold the highest standards of quality and integrity in all our services. Our goal is to build long-term relationships based on trust and satisfaction.'),
          buildBullet('Transparency: We value honesty and clarity in every interaction.'),

          const SizedBox(height: 20),
          buildTitle('Join the Qars Spin Community'),
          buildParagraph(
            'At Qars Spin, we are more than just a car service provider; we are a community of car enthusiasts '
                'and professionals dedicated to making your automotive experience enjoyable and hassle-free. '
                'Whether you\'re buying your first car, upgrading to a new model, or maintaining your current vehicle, '
                'we are here to assist you every step of the way.',
          ),
        ],
      ),
    );
  }
}
