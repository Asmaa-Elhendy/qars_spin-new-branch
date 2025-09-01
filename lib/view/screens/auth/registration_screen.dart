import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../controller/const/app_strings.dart';
import '../../../controller/const/colors.dart';
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
  bool _isLoading = false;
  
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
  
  // Generate a random OTP secret
  String _generateOtpSecret() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values).substring(0, 32);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.createAccount,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  hintText: AppStrings.enterYourMobileNumber,
               //   prefixText: '+${_countries.firstWhere((c) => c['code'] == _selectedCountry)['prefix']} ',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return AppStrings.fieldRequired;
                  //   }
                  //   // Basic validation for phone number (adjust as needed)
                  //   if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                  //     return AppStrings.invalidPhoneNumber;
                  //   }
                  //   return null;
                  // },
                ),
                 SizedBox(height: height*.02),
                // Submit Button
                PrimaryButton(
                  onPressed: (){},borderRadius: 4,
                  child: _isLoading
                      ?  SizedBox(
                          width: 20,
                          height: height*.06,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'REGISTER NOW',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                ),
              ]),

          ),
        ),
      ),
    );
  }
}
