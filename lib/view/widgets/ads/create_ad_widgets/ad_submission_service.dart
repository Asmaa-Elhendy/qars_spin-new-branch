import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../../controller/ads/data_layer.dart';
import '../../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../../../controller/my_ads/my_ad_data_layer.dart';
import '../../../../model/create_ad_model.dart';

class AdSubmissionService {
  static Future<void> submitAd({
    required BuildContext context,
    required List<String> images,
    required String coverImage,
    required String? videoPath,
    required String make,
    required String carClass,
    required String model,
    required String type,
    required String year,
    required String warranty,
    required String askingPrice,
    required String minimumPrice,
    required String mileage,
    required String plateNumber,
    required String chassisNumber,
    required String description,
    required Color exteriorColor,
    required Color interiorColor,
    required Function() showLoadingDialog,
    required Function(String, String) showSuccessDialog,
    required Function(String) showErrorDialog,
    required Function() hideLoadingDialog,
  }) async {
    try {
      showLoadingDialog();

      // Get the controller instance
      final AdCleanController brandController = Get.find<AdCleanController>();

      // Get selected IDs from the controller
      final selectedMake = brandController.selectedMake.value;
      final selectedClass = brandController.selectedClass.value;
      final selectedModel = brandController.selectedModel.value;
      final selectedCategory = brandController.selectedCategory.value;

      // Convert warranty to boolean
      bool warrantyAvailable = warranty.toLowerCase() == 'yes';

      // Get color values as hex strings
      String exteriorColorHex = '#${exteriorColor.value.toRadixString(16).substring(2)}';
      String interiorColorHex = '#${interiorColor.value.toRadixString(16).substring(2)}';

      // Create the ad data model
      CreateAdModel adData = CreateAdModel(
        makeId: selectedMake?.id.toString() ?? '',
        classId: selectedClass?.id.toString() ?? '',
        modelId: selectedModel?.id.toString() ?? '',
        categoryId: selectedCategory?.id.toString() ?? '',
        manufactureYear: year,
        minimumPrice: minimumPrice.isNotEmpty ? minimumPrice : '0',
        askingPrice: askingPrice,
        mileage: mileage,
        plateNumber: plateNumber.isNotEmpty ? plateNumber : '',
        chassisNumber: chassisNumber.isNotEmpty ? chassisNumber : '',
        postDescription: description,
        interiorColor: interiorColorHex,
        exteriorColor: exteriorColorHex,
        warrantyAvailable: warrantyAvailable ? 'yes' : 'no',
        userName:userName,
        ourSecret:ourSecret,
        selectedLanguage: 'en',
      );

      log('Submitting ad with data: ${adData.toJson()}');

      // Submit the ad to the backend
      final adRepository = AdRepository();
      final response = await adRepository.createCarAd(adModel: adData);

      log('API Response: $response');

      if (response['Code'] == 'OK' || response['Code']?.toString().toLowerCase() == 'ok') {
        String postId = response['ID']?.toString() ?? '';
        
        // Upload cover photo if we have a post ID and cover image
        if (postId.isNotEmpty && coverImage.isNotEmpty) {
          log('Uploading cover photo for post ID: $postId');
          await adRepository.uploadCoverPhoto(
            postId: postId,
            ourSecret: ourSecret, // Using the same secret as in ad creation
            imagePath: coverImage,
          );
          log('Cover photo upload completed');
        }
        
        // Upload gallery photos (all images except cover photo)
        if (postId.isNotEmpty && images.isNotEmpty) {
          log('Uploading gallery photos for post ID: $postId');
          await _uploadGalleryPhotos(
            postId: postId,
            images: images,
            coverImage: coverImage,
          );
          log('Gallery photos upload completed');
        }
        
        // Hide loading dialog only after both operations are complete
        hideLoadingDialog();
        
        String successMessage = postId.isNotEmpty 
            ? "Ad created successfully!\nPost ID: $postId" 
            : "Ad created successfully!";
        showSuccessDialog(successMessage, postId);
      } else {
        String errorMessage = response['Desc'] ?? 'Failed to create ad';
        log('Error response: Code=${response['Code']}, Desc=$errorMessage');
        showErrorDialog(errorMessage);
      }

    } catch (e) {
      hideLoadingDialog();
      log('Error submitting ad: $e');
      showErrorDialog('An error occurred while submitting your ad. Please try again.');
    }
  }

  // Removed fixed category mapping - now using dynamic category ID from controller

  static Future<bool> validateImageFiles({
    required List<String> images,
    required String coverImage,
    required String? videoPath,
    required Function(String) showErrorDialog,
  }) async
  {
    // Check if there are any images
    if (images.isEmpty) {
      showErrorDialog("Please upload at least one image");
      return false;
    }

    // Check if cover image exists in the images list
    if (coverImage.isNotEmpty && !images.contains(coverImage)) {
      showErrorDialog("Cover image must be one of the uploaded images");
      return false;
    }

    // Check maximum images limit
    if (images.length > 15) {
      showErrorDialog("Maximum 15 images allowed");
      return false;
    }

    // Check video limit
    if (videoPath != null && videoPath.isNotEmpty) {
      // You can add additional video validation here if needed
      log('Video path provided: $videoPath');
    }

    return true;
  }

  /// Upload gallery photos (excluding cover photo)
  static Future<void> _uploadGalleryPhotos({
    required String postId,
    required List<String> images,
    required String coverImage,
  }) async {
    try {
      // Get the MyAdCleanController instance
      final MyAdCleanController myAdController = Get.put(
        MyAdCleanController(MyAdDataLayer()),
      );
      
      // Filter out cover photo from images list
      final galleryImages = images.where((image) => image != coverImage).toList();
      
      log('Gallery images to upload: ${galleryImages.length} (excluding cover photo)');
      
      // Upload each gallery photo sequentially
      for (int i = 0; i < galleryImages.length; i++) {
        final imagePath = galleryImages[i];
        final file = File(imagePath);
        
        if (await file.exists()) {
          log('Uploading gallery photo ${i + 1}/${galleryImages.length}: $imagePath');
          
          final success = await myAdController.uploadPostGalleryPhoto(
            postId: postId,
            photoFile: file,
            ourSecret: ourSecret,
          );
          
          if (success) {
            log('✅ Gallery photo ${i + 1} uploaded successfully');
          } else {
            log('❌ Failed to upload gallery photo ${i + 1}: ${myAdController.uploadError.value}');
          }
        } else {
          log('❌ Gallery photo file not found: $imagePath');
        }
      }
      
      log('Gallery photos upload process completed');
    } catch (e) {
      log('❌ Error uploading gallery photos: $e');
    }
  }

  static void logAdSubmission({
    required String make,
    required String carClass,
    required String model,
    required String type,
    required String year,
    required String askingPrice,
    required int imageCount,
    required bool hasVideo,
  })
  {
    log('=== Ad Submission Log ===');
    log('Make: $make');
    log('Class: $carClass');
    log('Model: $model');
    log('Type: $type');
    log('Year: $year');
    log('Asking Price: $askingPrice');
    log('Image Count: $imageCount');
    log('Has Video: $hasVideo');
    log('========================');
  }

}
