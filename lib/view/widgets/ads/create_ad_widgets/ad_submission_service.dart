import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../../controller/ads/data_layer.dart';
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
        categoryId: _getCategoryId(type),
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
        userName: 'Asmaa2',
        ourSecret: '1244',
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
            ourSecret: '1244', // Using the same secret as in ad creation
            imagePath: coverImage,
          );
          log('Cover photo upload completed');
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

  static String _getCategoryId(String type) {
    // Map car types to category IDs
    switch (type.toLowerCase()) {
      case '4*4':
        return '1';
      case 'bus':
        return '2';
      case 'convertible':
        return '3';
      case 'coupe':
        return '4';
      case 'crossover':
        return '5';
      case 'electric vehicle (ev)':
        return '6';
      default:
        return '1'; // Default category
    }
  }

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
