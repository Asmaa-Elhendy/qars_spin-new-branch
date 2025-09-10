import 'package:get/get.dart';
import '../../model/car_brand.dart';
import '../../model/class_model.dart';
import 'data_layer.dart';

class AdCleanController extends GetxController {
  final AdRepository repository;
  AdCleanController(this.repository);

  // قائمة الماركات
  var carBrands = <CarBrand>[].obs;
  var selectedMake = Rxn<CarBrand>();

  // قائمة الكلاسات
  var carClasses = <CarClass>[].obs;
  var selectedClass = Rxn<CarClass>();

  // loading flags
  var isLoadingMakes = false.obs;
  var isLoadingClasses = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMakes();
  }

  void fetchMakes() async {
    isLoadingMakes.value = true;
    try {
      final makes = await repository.fetchCarMakes();
      carBrands.assignAll(makes);
    } finally {
      isLoadingMakes.value = false;
    }
  }

  void fetchCarClasses(String makeId) async {
    isLoadingClasses.value = true;
    carClasses.clear();
    selectedClass.value = null;

    try {
      final classes = await repository.fetchCarClasses(makeId);
      carClasses.assignAll(classes);
    } catch (e) {
      print("Error fetching classes: $e");
    } finally {
      isLoadingClasses.value = false;
    }
  }
}
