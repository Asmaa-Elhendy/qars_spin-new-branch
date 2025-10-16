import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/auth/auth_controller.dart';
import '../../../controller/const/app_strings.dart';
import '../../../controller/const/colors.dart';
import '../../widgets/ads/dialogs/otp_dialog.dart';
import '../../widgets/auth_widgets/country_dropdown.dart';
import '../../widgets/auth_widgets/custom_text_field.dart' as e;

class RegisterPage extends StatefulWidget {
 String code;
 String country;
 String mobile;
 RegisterPage({required this.code,required this.country,required this.mobile});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  // Country code and phone number state
  String _selectedCountry = 'QA';
  String _selectedCountryPrefix = '974';

  final List<Map<String, String>> _countries = [
    {'name': AppStrings.countryQatar, 'code': 'QA', 'prefix': '974'},
    {'name': AppStrings.countrySaudiArabia, 'code': 'SA', 'prefix': '966'},
    {'name': AppStrings.countryBahrain, 'code': 'BH', 'prefix': '973'},
    {'name': AppStrings.countryUAE, 'code': 'AE', 'prefix': '971'},
    {'name': AppStrings.countryOman, 'code': 'OM', 'prefix': '968'},
    {'name': AppStrings.countryKuwait, 'code': 'KW', 'prefix': '965'},
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mobileController.text=widget.mobile;
    _selectedCountry=widget.code;
    _selectedCountryPrefix=widget.country;
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
              BoxShadow(
                color: AppColors.blackColor(context).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        elevation: 0,
        title: Text(
          'Register',
          style: TextStyle(
            color: AppColors.blackColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  'Full Name(*)',
                  style: TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                e.CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter Full Name',

                ),
                const SizedBox(height: 8),
                Text(
                  'Email(*)',
                  style: TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                e.CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,

                ),
                const SizedBox(height: 8),
                Text(
                  'Country(*)',
                  style: TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [
                      Text(
                          _selectedCountry
                      ),
                      SizedBox(width: 8),
                      Text(
                        '+$_selectedCountryPrefix',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mobile Number(*)',
                  style: TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Text(
                          _mobileController.text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: height * .05,
                  child: GestureDetector(
                    onTap: () async {
                     if(_nameController.text.isEmpty||_mobileController.text.isEmpty||_emailController.text.isEmpty){
                       showErrorAlert('PLease fill all fields', context);
                       return;
                     }

                      if (!mounted) return;

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final authController = Get.find<AuthController>();

                        final response = await authController.registerUser(
                          userName: _mobileController.text,
                          fullName: _nameController.text,
                          email: _emailController.text,
                          mobileNumber: _mobileController.text,
                          selectedCountry: _selectedCountry,
                          firebaseToken: 'firebase_token_here',
                          preferredLanguage: 'en',
                          ourSecret: 'your_server_side_secret',
                        );

                        if (response['success'] == true) {
                          if (mounted) {
                            showSuccessDialog(
                              title: 'Success',
                              message: 'Registration successful!',
                              context: context,
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                          }
                        } else {
                          if (mounted) {
                            showErrorAlert(
                              response['message'] ?? 'Registration failed',
                              context,
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          showErrorAlert(
                            'An error occurred. Please try again.',
                            context,
                          );
                        }
                        debugPrint('Registration error: $e');
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child:  Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.w,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void showSuccessDialog({
    required String title,
    required String message,
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
