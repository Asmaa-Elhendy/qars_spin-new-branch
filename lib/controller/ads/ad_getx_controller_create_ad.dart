import 'package:get/get.dart';
import '../../model/car_brand.dart';
import '../../model/class_model.dart';
import '../../model/car_model_class.dart';
import '../../model/create_ad_model.dart';
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

  // قائمة الموديلات
  var carModels = <CarModelClass>[].obs;
  var selectedModel = Rxn<CarModelClass>();

  // Create ad state
  var isCreatingAd = false.obs;
  var createAdError = Rxn<String>();
  var createAdSuccess = Rxn<Map<String, dynamic>>();

  // loading flags
  var isLoadingMakes = false.obs;
  var isLoadingClasses = false.obs;
  var isLoadingModels = false.obs;

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

  void fetchCarModels(String classId) async {
    isLoadingModels.value = true;
    carModels.clear();
    selectedModel.value = null;

    try {
      final models = await repository.fetchCarModels(classId);
      carModels.assignAll(models);
    } catch (e) {
      print("Error fetching models: $e");
    } finally {
      isLoadingModels.value = false;
    }
  }



  /// إنشاء إعلان جديد
  Future<void> createAd({
    required CreateAdModel adData,
  }) async
  {
    isCreatingAd.value = true;
    createAdError.value = null;
    createAdSuccess.value = null;

    try {
      // Validate required selections
      if (selectedMake.value == null || 
          selectedClass.value == null || 
          selectedModel.value == null) {
        throw Exception('Please select valid Make, Class, and Model');
      }

      // Update the adData with selected make, class, and model
      CreateAdModel updatedAdData = CreateAdModel(
        makeId: selectedMake.value!.id.toString(),
        classId: selectedClass.value!.id.toString(),
        modelId: selectedModel.value!.id.toString(),
        categoryId: adData.categoryId,
        manufactureYear: adData.manufactureYear,
        minimumPrice: adData.minimumPrice,
        askingPrice: adData.askingPrice,
        mileage: adData.mileage,
        plateNumber: adData.plateNumber,
        chassisNumber: adData.chassisNumber,
        postDescription: adData.postDescription,
        interiorColor: adData.interiorColor,
        exteriorColor: adData.exteriorColor,
        warrantyAvailable: adData.warrantyAvailable,
        userName: adData.userName,
        ourSecret: adData.ourSecret,
        selectedLanguage: adData.selectedLanguage,
      );

      // Call API
      final result = await repository.createCarAd(adModel: updatedAdData);
      
      // Handle response
      if (result['Code'] == 'OK') {
        createAdSuccess.value = result;
      } else {
        throw Exception(result['Desc'] ?? 'Failed to create ad');
      }

    } catch (e) {
      createAdError.value = e.toString();
      print("Error creating ad: $e");
    } finally {
      isCreatingAd.value = false;
    }
  }

  /// Reset create ad state
  void resetCreateAdState() {
    isCreatingAd.value = false;
    createAdError.value = null;
    createAdSuccess.value = null;
  }

  /// Get missing required fields for validation
  List<String> getMissingRequiredFields({
    required CreateAdModel adData,
  })
  {
    List<String> missingFields = [];

    if (selectedMake.value == null) missingFields.add('Make');
    if (selectedClass.value == null) missingFields.add('Class');
    if (selectedModel.value == null) missingFields.add('Model');
    if (adData.categoryId.isEmpty) missingFields.add('Type');
    if (adData.manufactureYear.isEmpty) missingFields.add('Manufacture Year');
    if (adData.askingPrice.isEmpty) missingFields.add('Asking Price');
    if (adData.mileage.isEmpty) missingFields.add('Mileage');
    if (adData.plateNumber.isEmpty) missingFields.add('Plate Number');
    if (adData.chassisNumber.isEmpty) missingFields.add('Chassis Number');
    if (adData.postDescription.isEmpty) missingFields.add('Description');
    if (adData.interiorColor.isEmpty) missingFields.add('Interior Color');
    if (adData.exteriorColor.isEmpty) missingFields.add('Exterior Color');
    if (adData.warrantyAvailable.isEmpty) missingFields.add('Warranty');

    return missingFields;
  }
}
