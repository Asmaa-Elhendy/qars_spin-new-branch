import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/search_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/controller/specs/specs_controller.dart';
import 'package:qarsspin/controller/specs/specs_data_layer.dart';


import 'ads/ad_getx_controller_create_ad.dart';
import 'ads/data_layer.dart';
import 'auth/auth_controller.dart';
import 'brand_controller.dart';
import 'my_ads/my_ad_getx_controller.dart';
import 'my_ads/my_ad_data_layer.dart';

class MyBinding implements  Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut(() => BrandController(),fenix: true);
    Get.lazyPut(() => ShowRoomsController(),fenix: true);
    Get.lazyPut(() => RentalCarsController(),fenix: true);
    Get.lazyPut(() => SpecsController(SpecsDataLayer()),fenix:true);
    Get.lazyPut(() => AdCleanController(AdRepository()), fenix: true);
    Get.lazyPut(() => MyAdCleanController(MyAdDataLayer()), fenix: true);
    Get.lazyPut(() => MySearchController(),fenix: true);
    // In your main.dart or app bindings file


  }
}