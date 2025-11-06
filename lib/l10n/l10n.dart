import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/car_model.dart';
import 'app_localization.dart';

/// 🔹 اللغات المدعومة
class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
  ];
}

/// 🔹 الكنترولر المسؤول عن اللغة والتبديل بينها
class LanguageController extends GetxController {
  var currentLocale = const Locale('en'); // اللغة الافتراضية: إنجليزي

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  /// تغيير اللغة (العربية / الإنجليزية)
  void changeLanguage(String langCode) async {
    Locale newLocale;
    if (langCode == 'ar') {
      newLocale = const Locale('ar');
    } else {
      newLocale = const Locale('en');
    }

    currentLocale = newLocale;
    Get.updateLocale(newLocale);
    update();

    // حفظ اللغة في SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
  }

  /// تحميل اللغة المحفوظة عند فتح التطبيق
  void loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language');
    if (savedLang != null) {
      changeLanguage(savedLang);
    }
  }
}

/// 🔹 Extension للترجمة حسب المفتاح
extension LocalizationHelper on AppLocalizations {
  String getText(String key) {
    switch (key) {
      case 'sort_by_post_count':
        return sort_by_post_count;
      case 'sort_by_rating':
        return sort_by_rating;
      case 'sort_by_visit':
        return sort_by_visits;
      case 'sort_by_date':
        return sort_by_date;

    // new enum ones
      case 'carStatus_personal':
        return carStatus_personal;
      case 'carStatus_showroom':
        return carStatus_showroom;
      case 'carStatus_qarsSpin':
        return carStatus_qarsSpin;

      case 'free_ads':
        return free_ads;
      case 'free_360':
        return free_360;
      case 'after_sale_commission':
        return after_sale_commission;
      case 'private_seller_info':
        return private_seller_info;
      case 'standard_advertise':
        return standard_advertise;
      case 'show_contact_details':
        return show_contact_details;
      case 'upload_pictures_videos':
        return upload_pictures_videos;
      case 'optional_360_session':
        return optional_360_session;
      default:
        return key; // fallback لو المفتاح مش معروف
    }
  }
}
