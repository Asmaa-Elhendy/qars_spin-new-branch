import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/auth/auth_data_layer.dart';

bool registered = false;
class AuthController extends GetxController {
  final AuthDataLayer _authDataLayer = AuthDataLayer();
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Error message
  final RxString errorMessage = ''.obs;
  
  // Success message
  final RxString successMessage = ''.obs;

  // Request OTP
  Future<Map<String, dynamic>> requestOtp({
    required String userName,
    required String otpSecret,
    required String ourSecret,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authDataLayer.requestOtp(
        userName: userName,
        otpSecret: otpSecret,
        ourSecret: ourSecret,
      );

      if (response['success'] == true) {
        successMessage.value = response['message'] ?? 'OTP sent successfully';
      } else {
        errorMessage.value = response['message'] ?? 'Failed to send OTP';
      }
      return response;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      return {'success': false, 'message': errorMessage.value};
    } finally {
      isLoading.value = false;
    }
  }

  // Clear messages
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
}