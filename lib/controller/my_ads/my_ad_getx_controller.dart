import 'package:get/get.dart';
import '../../model/my_ad_model.dart';
import 'my_ad_data_layer.dart';

class MyAdCleanController extends GetxController {
  final MyAdDataLayer repository;

  MyAdCleanController(this.repository);

  // My Ads state
  var myAds = <MyAdModel>[].obs;
  var isLoadingMyAds = false.obs;
  var myAdsError = Rxn<String>();
  var myAdsResponse = Rxn<MyAdResponse>();

  @override
  void onInit() {
    super.onInit();
    fetchMyAds();
  }

  /// Fetch user's ads
  Future<void> fetchMyAds() async {
    isLoadingMyAds.value = true;
    myAdsError.value = null;
    myAdsResponse.value = null;

    try {
      final response = await repository.getListOfPostsByUserName(
        userName: 'Asmaa2',
        ourSecret: '1244',
      );

      if (response['Code'] == 'OK') {
        // Parse the response
        final myAdResponse = MyAdResponse.fromJson(response);
        myAdsResponse.value = myAdResponse;
        myAds.assignAll(myAdResponse.data);
      } else {
        myAdsError.value = response['Desc'] ?? 'Failed to fetch ads';
      }
    } catch (e) {
      myAdsError.value = 'Network error: ${e.toString()}';
      print('Error fetching my ads: $e');
    } finally {
      isLoadingMyAds.value = false;
    }
  }
}