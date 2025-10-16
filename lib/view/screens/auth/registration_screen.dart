import 'dart:developer' as l;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/auth/secret.dart';
import 'package:qarsspin/view/screens/auth/register_detail.dart';

import '../../../controller/auth/auth_controller.dart';
import '../../../controller/const/app_strings.dart';
import '../../../controller/const/colors.dart';
import '../../widgets/ads/dialogs/error_dialog.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/ads/dialogs/otp_dialog.dart';
import '../../widgets/auth_widgets/country_dropdown.dart';
import '../../widgets/auth_widgets/custom_text_field.dart';
import '../../widgets/auth_widgets/primary_button.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _showOtpField = false;
  String? _otpSecret;
  int? _otpCount;
  String? _phoneNumber;

  // Country data matching the Android app
  final List<Map<String, String>> _countries = [
    {'name': AppStrings.countryQatar, 'code': 'QA', 'prefix': '974'},
    {'name': AppStrings.countrySaudiArabia, 'code': 'SA', 'prefix': '966'},
    {'name': AppStrings.countryBahrain, 'code': 'BH', 'prefix': '973'},
    {'name': AppStrings.countryUAE, 'code': 'AE', 'prefix': '971'},
    {'name': AppStrings.countryOman, 'code': 'OM', 'prefix': '968'},
    {'name': AppStrings.countryKuwait, 'code': 'KW', 'prefix': '965'},
  ];

  String _selectedCountry = 'QA';
  String _selectedCountryPrefix = '974';
  final _authController = Get.find<AuthController>();

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      _phoneNumber = '${_selectedCountry}${_selectedCountryPrefix}${_mobileController.text}';
      _otpSecret = (Random().nextInt((9989 - 1001) + 1) + 1001).toString();
      
      // Show OTP in console for testing
      l.log('Phone: $_phoneNumber');
      l.log('OTP for testing: $_otpSecret');

      final response = await _authController.requestOtp(
        userName: _phoneNumber!,
        otpSecret: _otpSecret!,
        ourSecret:ourSecret,
      );//j

      if (response['success'] == true) {
        _otpCount = response['data']?['Count'] ?? 0;
        // Show OTP dialog instead of showing field in the same screen
        _showOtpDialog();
      } else {
        _showErrorAlert(response['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      _showErrorAlert('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showOtpDialog() {
    final otpController = TextEditingController();
    OTPDialog.show(
      context: context,
      otpController: otpController,
      otpSecret: _otpSecret!,
      otpCount: _otpCount!,
      isLoading: _isLoading,
      onLoadingChange: (v) => setState(() => _isLoading = v),
      onValidOTP: () => Get.offAllNamed('/home'),
      onInvalidOTP: () {},
      onRegister: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
      request: false,
    );

    // Get.dialog(
    //   AlertDialog(
    //     backgroundColor: AppColors.background(Get.context!),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12.r),
    //     ),
    //     title: Text(
    //       'Enter OTP',
    //       style: TextStyle(
    //         fontSize: 18.sp,
    //         fontWeight: FontWeight.bold,
    //         color: AppColors.textPrimary(Get.context!),
    //       ),
    //     ),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(
    //           'Please enter the OTP sent to your phone',
    //           style: TextStyle(
    //             fontSize: 14.sp,
    //             color: AppColors.textSecondary(Get.context!),
    //           ),
    //         ),
    //         SizedBox(height: 20.h),
    //         TextField(
    //           controller: otpController,
    //           keyboardType: TextInputType.number,
    //           decoration: InputDecoration(
    //             hintText: 'Enter OTP',
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8.r),
    //               borderSide: BorderSide(
    //                 color: Colors.grey.shade300,
    //               ),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(8.r),
    //               borderSide: BorderSide(
    //                 color: Theme.of(Get.context!).primaryColor,
    //               ),
    //             ),
    //             contentPadding: EdgeInsets.symmetric(
    //               horizontal: 16.w,
    //               vertical: 12.h,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     actions: [
    //
    //       ElevatedButton(
    //         onPressed: () async {
    //           if (otpController.text.isEmpty) {
    //             _showErrorAlert('Please enter the OTP');
    //             return;
    //           }
    //
    //           Get.back();
    //           setState(() => _isLoading = true);
    //
    //           try {
    //             if (otpController.text == _otpSecret) {
    //               l.log('${otpController.text}    ${_otpSecret}');
    //               if (_otpCount == 1) {
    //                 // User is not registered, navigate to home
    //                 Get.offAllNamed('/home');
    //               } else {
    //                 //enter detail screen
    //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
    //               }
    //             } else {
    //               _showErrorAlert('Invalid OTP. Please try again.');
    //             }
    //           } catch (e) {
    //             _showErrorAlert('An error occurred. Please try again.');
    //           } finally {
    //             if (mounted) {
    //               setState(() => _isLoading = false);
    //             }
    //           }
    //         },
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: Theme.of(Get.context!).primaryColor,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8.r),
    //           ),
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 24.w,
    //             vertical: 12.h,
    //           ),
    //         ),
    //         child: Text(
    //           'VERIFY',
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 14.sp,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   barrierDismissible: false,
    // );
  }

  void _showErrorAlert(String message) {
    ErrorDialog.show(

      context,
      message,
          () {
       // Navigator.pop(context);
      }, fromOtp:true,
      isModifyMode: false,

    );
  }

  @override
  void initState() {
    super.initState();
    // Clear any previous messages when screen initializes
    _authController.clearMessages();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background(context),
        toolbarHeight: 60.h,
        shadowColor: Colors.grey.shade300,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.background(context),
            boxShadow: [
              BoxShadow( //update asmaa
                color: AppColors.blackColor(context).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        elevation: 0, // نشيل الشادو الافتراضي

        title: Text(
            AppStrings.createAccount,
          style: TextStyle(
            color: AppColors.blackColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Country Selection
                  Text(
                    AppStrings.yourCountry,
                    style:  TextStyle(
                      fontSize: 17.w,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Country Dropdown
                  CountryDropdown(
                    countries: _countries,
                    onCountrySelected: (country) {
                      setState(() {
                        _selectedCountry = country['code']!;
                        _selectedCountryPrefix = country['prefix']!;
                      });
                    },
                    selectedCountry: _countries.firstWhere(
                      (c) => c['code'] == _selectedCountry,
                      orElse: () => _countries.first,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Mobile Number
                  Text(
                    AppStrings.yourMobileNumber,
                    style:  TextStyle(
                      fontSize: 17.w,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    hintText: AppStrings.enterYourMobileNumber,
                 //   prefixText: '+${_countries.firstWhere((c) => c['code'] == _selectedCountry)['prefix']} ',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      // Basic validation for phone number (adjust as needed)
                      if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                        return AppStrings.invalidPhoneNumber;
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: height*.02),
                  // OTP Field (shown after initial request)
                  if (_showOtpField) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter OTP',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'OTP is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Submit Button
                  PrimaryButton(
                    onPressed: _isLoading ? null : _requestOtp,
                    borderRadius: 4,
                    child: Text(
                      'REGISTER NOW',
                      style: TextStyle(
                        fontSize: 17.w, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: AppLoadingWidget(
                  title: 'Loading...\nPlease Wait...',
                ),
              ),
            ),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
