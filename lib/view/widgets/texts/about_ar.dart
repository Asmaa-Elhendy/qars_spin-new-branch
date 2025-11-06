import 'package:flutter/material.dart';

import '../../../controller/const/colors.dart';

class AboutAr extends StatelessWidget {
  const AboutAr({super.key});

  Text buildTitle(String text,context) => Text(
    text,
    textDirection: TextDirection.rtl,
    style:  TextStyle(
      color: AppColors.blackColor(context),
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 2,
    ),
  );

  Text buildParagraph(String text,context) => Text(
    text,
    textDirection: TextDirection.rtl,
    style:  TextStyle(
      color: AppColors.blackColor(context),
      fontSize: 15,
      height: 1.6,
    ),
  );

  Widget buildBullet(String text,context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    textDirection: TextDirection.rtl,
    children: [
      Text(
        "• ",
        textDirection: TextDirection.rtl,
        style: TextStyle(color: AppColors.blackColor(context), fontSize: 16),
      ),
      Expanded(
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          style:  TextStyle(
            color: AppColors.blackColor(context),
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
                    'سواء كنت تشتري سيارة جديدة، أو تبيع سيارة مستعملة، أو تبحث عن خدمات لسيارتك الحالية.',context
            ),

            const SizedBox(height: 20),
            buildTitle('خدماتنا الشاملة',context),
            buildBullet('شراء وبيع السيارات',context),
            buildBullet('فحص السيارات',context),
            buildBullet('خدمة الأعطال على الطريق',context),
            buildBullet('تسجيل السيارات',context),
            buildBullet('خدمة اللوحات المميزة',context),
            buildBullet('خدمة الدفع الآمن',context),
            buildBullet('خدمات التقسيط (EMI)',context),

            const SizedBox(height: 20),
            buildTitle('لماذا تختار قارس سبين؟',context),
            buildBullet(
                'نهج يركز على العميل: عملاؤنا هم محور كل ما نقوم به، ونحن ملتزمون بتقديم خدمة استثنائية مصممة لتلبية احتياجاتك الخاصة.',context),
            buildBullet(
                'الخبرة والتجربة: بفضل سنوات من الخبرة في مجال السيارات، يمتلك فريقنا معرفة كافية لتقديم النصائح والدعم في كل خطوة من رحلة شراء أو بيع سيارتك.',context),
            buildBullet(
                'الجودة والثقة: نحن نلتزم بأعلى معايير الجودة والنزاهة في جميع خدماتنا. هدفنا هو بناء علاقات طويلة الأمد قائمة على الثقة والرضا.',context),
            buildBullet('الشفافية: نحن نؤمن بالوضوح والصدق في جميع تعاملاتنا.',context),

            const SizedBox(height: 20),
            buildTitle('انضم إلى مجتمع قارس سبين',context),
            buildParagraph(
                'في قارس سبين، نحن أكثر من مجرد مزود خدمات سيارات؛ '
                    'نحن مجتمع من عشاق السيارات والمحترفين المكرسين لجعل تجربتك في عالم السيارات ممتعة وخالية من المتاعب. '
                    'سواء كنت تشتري سيارتك الأولى، أو تقوم بترقية سيارتك الحالية، أو تحتاج إلى صيانة، '
                    'فنحن هنا لمساعدتك في كل خطوة على الطريق.',context
            ),
          ],
        ),
      ),
    );
  }
}
