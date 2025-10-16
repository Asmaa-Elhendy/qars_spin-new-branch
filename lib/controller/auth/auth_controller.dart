import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/auth/auth_data_layer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class AuthController extends GetxController {
  final AuthDataLayer _authDataLayer = AuthDataLayer();
  
  // Registered state
  final RxBool _registered = false.obs;
  
  // Getter for registered state
  bool get registered => _registered.value;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Error message
  final RxString errorMessage = ''.obs;
  
  // Success message
  final RxString successMessage = ''.obs;

  // Get the current user's full name
  String? get userFullName => _fullName.value;
  final RxString _fullName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    // Load user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _registered.value = prefs.getString('mobileNumber')?.isNotEmpty ?? false;
    if (_registered.value) {
      _fullName.value = prefs.getString('fullName') ?? '';
    }
    
    // Print current user data
    log('User is ${_registered.value ? 'registered' : 'not registered'}');
    if (_registered.value) {
      log('Mobile Number: ${prefs.getString('mobileNumber')}');
      log('Full Name: ${_fullName.value}');
    }
  }
  
  // Update user data in SharedPreferences
  Future<void> _updateUserData(String username, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('fullName', fullName);
    _registered.value = true;
    _fullName.value = fullName;
  }

  // Clear user data (for logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Log the data before clearing (for debugging)
    final mobileNumber = prefs.getString('mobileNumber');
    final fullName = prefs.getString('fullName');
    
    // Clear all user data
    await prefs.remove('mobileNumber');
    await prefs.remove('fullName');
    
    // Update the state
    _registered.value = false;
    _fullName.value = '';
    
    // Log the action
    log('User signed out. Cleared data:', 
        name: 'AuthController',
        error: 'Mobile: $mobileNumber, Full Name: $fullName');
  }

  // Get current user data
  Map<String, String> getCurrentUser() {
    return {
      'username': _registered.value ? _fullName.value : '',
      'fullName': _fullName.value,
    };
  }

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
        // Save user data to SharedPreferences
        await _updateUserData(userName, fullName);
        
        successMessage.value = response['message'] ?? 'Registration successful';
        return {'success': true, 'message': successMessage.value, 'data': response['data']};
      } else {
        errorMessage.value = response['message'] ?? 'Failed to register user';
        return {'success': false, 'message': errorMessage.value};
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during registration';
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