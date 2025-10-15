import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  @override
  void onInit() {
    super.onInit();
    bool isDark = _storage.read(_key) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  bool get isDarkMode => themeMode.value == ThemeMode.dark;


  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      _storage.write(_key, true);
    } else {
      themeMode.value = ThemeMode.light;
      _storage.write(_key, false);
    }
  }
}