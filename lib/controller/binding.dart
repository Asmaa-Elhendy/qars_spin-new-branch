import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/controller/specs_controller.dart';

import 'ads/ad_getx_controller_create_ad.dart';
import 'ads/data_layer.dart';
import 'brand_controller.dart';

class MyBinding implements  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BrandController(),fenix: true);
    Get.lazyPut(() => ShowRoomsController(),fenix: true);
    Get.lazyPut(() => RentalCarsController(),fenix: true);
    Get.lazyPut(() => SpecsController(),fenix:true);
    Get.lazyPut(() => AdCleanController(AdRepository()), fenix: true);
  }
}