import 'package:flutter/material.dart';

class AboutAr extends StatelessWidget {
  const AboutAr({super.key});

  Text buildTitle(String text) => Text(
    text,
    textDirection: TextDirection.rtl,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 2,
    ),
  );

  Text buildParagraph(String text) => Text(
    text,
    textDirection: TextDirection.rtl,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 15,
      height: 1.6,
    ),
  );

  Widget buildBullet(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: TextDirection.rtl,
    children: [
      const Text(
        "• ",
        textDirection: TextDirection.rtl,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      Expanded(
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildParagraph(
              'مرحبًا بك في قارس سبين، وجهتك المثالية لكل ما يتعلق بالسيارات. '
                  'في قارس سبين، نحن ندرك أن شراء أو بيع سيارة قد يكون قرارًا كبيرًا وأحيانًا مرهقًا، '
                  'ولهذا نحن ملتزمون بتقديم خدمة شاملة وشفافة وسلسة تغطي جميع جوانب العملية. '
                  'مهمتنا هي جعل تجربة امتلاك السيارة تجربة ممتعة وخالية من التوتر، '
                  'سواء كنت تشتري سيارة جديدة، أو تبيع سيارة مستعملة، أو تبحث عن خدمات لسيارتك الحالية.',
            ),

            const SizedBox(height: 20),
            buildTitle('خدماتنا الشاملة'),
            buildBullet('شراء وبيع السيارات'),
            buildBullet('فحص السيارات'),
            buildBullet('خدمة الأعطال على الطريق'),
            buildBullet('تسجيل السيارات'),
            buildBullet('خدمة اللوحات المميزة'),
            buildBullet('خدمة الدفع الآمن'),
            buildBullet('خدمات التقسيط (EMI)'),

            const SizedBox(height: 20),
            buildTitle('لماذا تختار قارس سبين؟'),
            buildBullet(
                'نهج يركز على العميل: عملاؤنا هم محور كل ما نقوم به، ونحن ملتزمون بتقديم خدمة استثنائية مصممة لتلبية احتياجاتك الخاصة.'),
            buildBullet(
                'الخبرة والتجربة: بفضل سنوات من الخبرة في مجال السيارات، يمتلك فريقنا معرفة كافية لتقديم النصائح والدعم في كل خطوة من رحلة شراء أو بيع سيارتك.'),
            buildBullet(
                'الجودة والثقة: نحن نلتزم بأعلى معايير الجودة والنزاهة في جميع خدماتنا. هدفنا هو بناء علاقات طويلة الأمد قائمة على الثقة والرضا.'),
            buildBullet('الشفافية: نحن نؤمن بالوضوح والصدق في جميع تعاملاتنا.'),

            const SizedBox(height: 20),
            buildTitle('انضم إلى مجتمع قارس سبين'),
            buildParagraph(
              'في قارس سبين، نحن أكثر من مجرد مزود خدمات سيارات؛ '
                  'نحن مجتمع من عشاق السيارات والمحترفين المكرسين لجعل تجربتك في عالم السيارات ممتعة وخالية من المتاعب. '
                  'سواء كنت تشتري سيارتك الأولى، أو تقوم بترقية سيارتك الحالية، أو تحتاج إلى صيانة، '
                  'فنحن هنا لمساعدتك في كل خطوة على الطريق.',
            ),
          ],
        ),
      ),
    );
  }
}
