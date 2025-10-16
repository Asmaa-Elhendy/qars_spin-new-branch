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

  // Register new user
  Future<Map<String, dynamic>> registerUser({
    required String userName,
    required String fullName,
    required String email,
    required String mobileNumber,
    required String selectedCountry,
    required String firebaseToken,
    required String preferredLanguage,
    required String ourSecret,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authDataLayer.registerUser(
        userName: userName,
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        selectedCountry: selectedCountry,
        firebaseToken: firebaseToken,
        preferredLanguage: preferredLanguage,
        ourSecret: ourSecret,
      );

      if (response['success'] == true) {
        successMessage.value = response['message'] ?? 'Registration successful';
        return {'success': true, 'message': successMessage.value, 'data': response['data']};
      } else {
        errorMessage.value = response['message'] ?? 'Failed to register user';
        return {'success': false, 'message': errorMessage.value};
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during registration: $e';
      return {'success': false, 'message': errorMessage.value};
    } finally {
      isLoading.value = false;
    }
  }

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
        return {'success': true, 'message': successMessage.value};
      } else {
        errorMessage.value = response['message'] ?? 'Failed to send OTP';
        return {'success': false, 'message': errorMessage.value};
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
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