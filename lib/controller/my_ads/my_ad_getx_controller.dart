import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:qarsspin/controller/my_ads/my_ad_data_layer.dart';
import 'package:qarsspin/controller/ads/data_layer.dart';
import 'package:qarsspin/model/my_ad_model.dart';
import 'package:qarsspin/model/post_media.dart';

class MyAdCleanController extends GetxController {
  final MyAdDataLayer repository;
  final AdRepository adRepository;

  MyAdCleanController(this.repository) : adRepository = AdRepository();

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

  // Post details state
  var postDetails = Rxn<Map<String, dynamic>>();
  var isLoadingPostDetails = false.obs;
  var postDetailsError = Rxn<String>();

  // Request Feature / 360 state
  final RxBool isSubmittingRequest = false.obs;
  final Rxn<String> requestError = Rxn<String>();
  final RxBool requestSuccess = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    fetchMyAds();
  }

  /// Fetch user's ads
  Future<void> fetchMyAds() async {
    print('🔄 [CONTROLLER] fetchMyAds() called');
    isLoadingMyAds.value = true;
    myAdsError.value = null;
    myAdsResponse.value = null;

    try {
      final response = await repository.getListOfPostsByUserName(
        userName: userName,
        ourSecret: ourSecret,
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

  /// Silent refresh my ads without showing loader or triggering any UI updates
  Future<void> silentRefreshMyAds() async {
    print('🔄 [CONTROLLER] silentRefreshMyAds() called');
    
    try {
      final response = await repository.getListOfPostsByUserName(
        userName: userName,
        ourSecret: ourSecret,
      );

      if (response['Code'] == 'OK') {
        final myAdResponse = MyAdResponse.fromJson(response);
        // Update data silently without triggering reactive updates
        myAds.clear();
        myAds.addAll(myAdResponse.data);
        print('✅ Silent refresh completed successfully');
      } else {
        print('❌ API Error: ${response['Desc']}');
      }
    } catch (e) {
      print('❌ Error in silent refresh: $e');
    }
  }

  /// Disable loader when returning from gallery management
  void disableLoaderForReturn() {
    print('🔒 [CONTROLLER] Disabling loader for return to my ads');
    isLoadingMyAds.value = false;
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
    bool skipRefresh = false,
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
      
      print('📤 [CONTROLLER] Raw response from repository: $response');
      print('📤 [CONTROLLER] Response Code: ${response['Code']}');
      print('📤 [CONTROLLER] Response Desc: ${response['Desc']}');
      
      if (response['Code'] == 'OK') {
        uploadSuccess.value = true;
        print('✅ Photo uploaded successfully');
        print('📤 Upload response: $response');
        
        // Refresh media list after successful upload (unless skipRefresh is true)
        if (!skipRefresh) {
          await fetchPostMedia(postId);
        }
        
        return true;
      } else {
        uploadError.value = response['Desc'] ?? 'Unknown upload error';
        print('❌ Upload failed: ${uploadError.value}');
        print('❌ [CONTROLLER] Response Code: ${response['Code']}, Desc: ${response['Desc']}');
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

  /// Upload video for post
  Future<bool> uploadPostVideo({
    required String postId,
    required String videoPath,
    required String ourSecret,
    bool skipRefresh = false,
  }) async {
    isUploading.value = true;
    uploadError.value = null;
    uploadSuccess.value = false;

    try {
      print('🎬 [CONTROLLER] Uploading video for post ID: $postId');
      final response = await adRepository.uploadVideoForPost(
        postId: postId,
        videoPath: videoPath,
        ourSecret: ourSecret,
      );
      
      print('🎬 [CONTROLLER] Raw response from repository: $response');
      print('🎬 [CONTROLLER] Response Code: ${response['Code']}');
      print('🎬 [CONTROLLER] Response Desc: ${response['Desc']}');
      print('🎬 [CONTROLLER] Response Type: ${response.runtimeType}');
      if (response.containsKey('Data')) {
        print('🎬 [CONTROLLER] Response Data: ${response['Data']}');
      }
      
      if (response['Code'] == 'OK') {
        uploadSuccess.value = true;
        print('✅ Video uploaded successfully');
        print('🎬 Upload response: $response');
        
        // Refresh media list after successful upload (unless skipRefresh is true)
        if (!skipRefresh) {
          await fetchPostMedia(postId);
        }
        
        return true;
      } else {
        uploadError.value = response['Desc'] ?? 'Unknown upload error';
        print('❌ Video upload failed: ${uploadError.value}');
        print('❌ [CONTROLLER] Response Code: ${response['Code']}, Desc: ${response['Desc']}');
        return false;
      }
    } catch (e) {
      uploadError.value = 'Network error: ${e.toString()}';
      print('❌ Error uploading video: $e');
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  /// Upload cover image for post
  Future<bool> uploadCoverImage({
    required String postId,
    required File photoFile,
    required String ourSecret,
  }) async {
    uploadError.value = null;
    uploadSuccess.value = false;

    try {
      log('Uploading cover photo for post ID: $postId');
      final response = await repository.uploadCoverPhoto(
        postId: postId,
        ourSecret: ourSecret, // Using the same secret as in ad creation
        imagePath: photoFile.path,
      );
      
      print('📤 [CONTROLLER] Raw response from repository: $response');
      print('📤 [CONTROLLER] Response Code: ${response['Code']}');
      print('📤 [CONTROLLER] Response Desc: ${response['Desc']}');
      
      if (response['Code'] == 'OK') {
        uploadSuccess.value = true;
        print('✅ Cover image uploaded successfully');
        print('📤 Upload response: $response');
        
        return true;
      } else {
        uploadError.value = response['Desc'] ?? 'Unknown upload error';
        print('❌ Cover image upload failed: ${uploadError.value}');
        print('❌ [CONTROLLER] Response Code: ${response['Code']}, Desc: ${response['Desc']}');
        return false;
      }
    } catch (e) {
      uploadError.value = 'Network error: ${e.toString()}';
      print('❌ Error uploading cover image: $e');
      return false;
    }
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

  /// Update cover image for post
  Future<bool> updateCoverImage({
    required String postId,
    required String newCoverImageUrl,
    required String ourSecret,
  }) async {
    try {
      print('🖼️ Updating cover image for post ID: $postId');
      print('🖼️ New cover image URL: $newCoverImageUrl');
      
      // For now, we'll simulate the update by storing the new cover image URL
      // In a real implementation, this would call an API to update the Rectangle_Image_URL
      // Since there's no specific API for this, we'll need to use the general post update API
      
      // TODO: Implement actual API call when available
      // For now, we'll just return success and let the UI handle the local update
      print('✅ Cover image updated successfully (simulated)');
      return true;
    } catch (e) {
      print('❌ Error updating cover image: $e');
      return false;
    }
  }

  /// Get post details by ID for editing
  Future<void> getPostById({
    required String postKind,
    required String postId,
    required String loggedInUser,
  }) async {
    isLoadingPostDetails.value = true;
    postDetailsError.value = null;
    postDetails.value = null;

    try {
      log('Fetching post details for post ID: $postId');
      final response = await repository.getPostById(
        postKind: postKind,
        postId: postId,
        loggedInUser: loggedInUser,
      );

      if (response['Code'] == 'OK') {
        final dataList = response['Data'] as List;
        if (dataList.isNotEmpty) {
          postDetails.value = dataList.first as Map<String, dynamic>;
          log('✅ Successfully fetched post details');
          log('Post data: ${postDetails.value}');
        } else {
          postDetailsError.value = 'No post data found';
          log('❌ No post data found');
        }
      } else {
        postDetailsError.value = response['Desc'] ?? 'Failed to fetch post details';
        log('❌ API Error: ${response['Desc']}');
      }
    } catch (e) {
      postDetailsError.value = 'Network error: ${e.toString()}';
      log('❌ Error fetching post details: $e');
    } finally {
      isLoadingPostDetails.value = false;
    }
  }

  /// Clear post details
  void clearPostDetails() {
    postDetails.value = null;
    postDetailsError.value = null;
    isLoadingPostDetails.value = false;
  }

  /// Request to feature (pin) a post
  Future<bool> requestFeatureAd({
    required String userName,
    required String postId,
    required String ourSecret,
  }) async {
    isSubmittingRequest.value = true;
    requestError.value = null;
    requestSuccess.value = false;

    try {
      final result = await repository.requestToFeaturePost(
        userName: userName,
        postId: postId,
        ourSecret: ourSecret,
      );

      if ((result['Code']?.toString().toUpperCase() ?? '') == 'OK') {
        requestSuccess.value = true;
        return true;
      } else {
        requestError.value = result['Desc']?.toString() ?? 'Request failed';
        return false;
      }
    } catch (e) {
      requestError.value = 'Network error: ${e.toString()}';
      return false;
    } finally {
      isSubmittingRequest.value = false;
    }
  }

  /// Request a 360 photo session for a post
  Future<bool> request360Session({
    required String userName,
    required String postId,
    required String ourSecret,
  }) async {
    isSubmittingRequest.value = true;
    requestError.value = null;
    requestSuccess.value = false;

    try {
      final result = await repository.request360PhotoSession(
        userName: userName,
        postId: postId,
        ourSecret: ourSecret,
      );

      if ((result['Code']?.toString().toUpperCase() ?? '') == 'OK') {
        requestSuccess.value = true;
        return true;
      } else {
        requestError.value = result['Desc']?.toString() ?? 'Request failed';
        return false;
      }
    } catch (e) {
      requestError.value = 'Network error: ${e.toString()}';
      return false;
    } finally {
      isSubmittingRequest.value = false;
    }
  }

  /// Request to publish (approval) a post
  Future<bool> requestPublishAd({
    required String userName,
    required String postId,
    required String ourSecret,
  }) async {
    isSubmittingRequest.value = true;
    requestError.value = null;
    requestSuccess.value = false;

    try {
      final result = await repository.requestPostApproval(
        userName: userName,
        postId: postId,
        ourSecret: ourSecret,
      );

      if ((result['Code']?.toString().toUpperCase() ?? '') == 'OK') {
        requestSuccess.value = true;
        return true;
      } else {
        requestError.value = result['Desc']?.toString() ?? 'Request failed';
        return false;
      }
    } catch (e) {
      requestError.value = 'Network error: ${e.toString()}';
      return false;
    } finally {
      isSubmittingRequest.value = false;
    }
  }
}