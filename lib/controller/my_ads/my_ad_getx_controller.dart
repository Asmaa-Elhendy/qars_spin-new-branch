import 'dart:io';
import 'package:get/get.dart';
import 'package:qarsspin/controller/my_ads/my_ad_data_layer.dart';
import 'package:qarsspin/model/my_ad_model.dart';
import 'package:qarsspin/model/post_media.dart';

class MyAdCleanController extends GetxController {
  final MyAdDataLayer repository;

  MyAdCleanController(this.repository);

  // My Ads state
  var myAds = <MyAdModel>[].obs;
  var isLoadingMyAds = false.obs;
  var myAdsError = Rxn<String>();
  var myAdsResponse = Rxn<MyAdResponse>();
  
  // Computed property for active ads count
  int get activeAdsCount => myAds.where((ad) => ad.postStatus == 'Active').length;

  // Media state
  var postMedia = Rxn<PostMedia>();
  var isLoadingMedia = false.obs;
  var mediaError = Rxn<String>();

  // Upload state
  final RxBool isUploading = RxBool(false);
  final Rxn<String> uploadError = Rxn<String>();
  final RxBool uploadSuccess = RxBool(false);

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
        final myAdResponse = MyAdResponse.fromJson(response);
        myAdsResponse.value = myAdResponse;
        
        // Print only Rectangle_Image_URL for each post
        for (int i = 0; i < myAdResponse.data.length; i++) {
          final post = myAdResponse.data[i];
          print('${post.rectangleImageUrl}');
        }
        
        myAds.assignAll(myAdResponse.data);
      } else {
        myAdsError.value = response['Desc'] ?? 'Failed to fetch ads';
        print('❌ API Error: ${response['Desc']}');
      }
    } catch (e) {
      myAdsError.value = 'Network error: ${e.toString()}';
      print('❌ Error fetching my ads: $e');
    } finally {
      isLoadingMyAds.value = false;
    }
  }

  /// Fetch media for a specific post
  Future<void> fetchPostMedia(String postId) async {
    isLoadingMedia.value = true;
    mediaError.value = null;
    postMedia.value = null;

    try {
      print('Fetching media for post ID: $postId');
      final mediaResponse = await repository.getMediaOfPostByID(postId: postId);
      
      if (mediaResponse.code == 'OK') {
        postMedia.value = mediaResponse;
        print('✅ Successfully fetched ${mediaResponse.count} media items');
        print('Media URLs: ${mediaResponse.data.map((m) => m.mediaUrl).toList()}');
      } else {
        mediaError.value = mediaResponse.desc;
        print('❌ API Error fetching media: ${mediaResponse.desc}');
      }
    } catch (e) {
      mediaError.value = 'Network error: ${e.toString()}';
      print('❌ Error fetching post media: $e');
    } finally {
      isLoadingMedia.value = false;
    }
  }

  Future<bool> uploadPostGalleryPhoto({
    required String postId,
    required File photoFile,
    required String ourSecret,
  }) async {
    isUploading.value = true;
    uploadError.value = null;
    uploadSuccess.value = false;

    try {
      print('📤 Uploading photo for post ID: $postId');
      final response = await repository.uploadPostGalleryPhoto(
        postId: postId,
        photoFile: photoFile,
        ourSecret: ourSecret,
      );
      
      if (response['Code'] == 'OK') {
        uploadSuccess.value = true;
        print('✅ Photo uploaded successfully');
        print('📤 Upload response: $response');
        
        // Refresh media list after successful upload
        await fetchPostMedia(postId);
        
        return true;
      } else {
        uploadError.value = response['Desc'] ?? 'Unknown upload error';
        print('❌ Upload failed: ${uploadError.value}');
        return false;
      }
    } catch (e) {
      uploadError.value = 'Network error: ${e.toString()}';
      print('❌ Error uploading photo: $e');
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  void resetUploadState() {
    isUploading.value = false;
    uploadError.value = null;
    uploadSuccess.value = false;
  }

  Future<bool> deletePostGalleryPhoto({
    required String mediaId,
    required String postId,
    required String ourSecret,
  }) async {
    try {
      print('🗑️ Deleting gallery image with media ID: $mediaId');
      final response = await repository.deleteGalleryImage(
        mediaId: mediaId,
        ourSecret: ourSecret,
      );
      
      if (response['Code'] == 'OK') {
        print('✅ Gallery image deleted successfully');
        print('🗑️ Delete response: $response');
        
        // Refresh media list after successful deletion
        await fetchPostMedia(postId);
        
        return true;
      } else {
        print('❌ Delete failed: ${response['Desc']}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting gallery image: $e');
      return false;
    }
  }
}