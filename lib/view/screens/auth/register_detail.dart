import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/const/app_strings.dart';
import '../../../controller/const/colors.dart';
import '../../widgets/ads/dialogs/otp_dialog.dart';
import '../../widgets/ads/text_field.dart';
import '../../widgets/auth_widgets/country_dropdown.dart';
import '../../widgets/auth_widgets/custom_text_field.dart' as e;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Country code and phone number state
  String _selectedCountry = 'QA';
  final List<Map<String, String>> _countries = [
    {'name': AppStrings.countryQatar, 'code': 'QA', 'prefix': '974'},
    {'name': AppStrings.countrySaudiArabia, 'code': 'SA', 'prefix': '966'},
    {'name': AppStrings.countryBahrain, 'code': 'BH', 'prefix': '973'},
    {'name': AppStrings.countryUAE, 'code': 'AE', 'prefix': '971'},
    {'name': AppStrings.countryOman, 'code': 'OM', 'prefix': '968'},
    {'name': AppStrings.countryKuwait, 'code': 'KW', 'prefix': '965'},
  ];

  String _selectedCountryPrefix = '974';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar:  AppBar(
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
        //  key: _formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                Text(
                  'Full Name(*)',
                  style:  TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),

                e.CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Email(*)',
                  style:  TextStyle(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                // Country Selection
                Text(
                  'Country(*)',
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
                const SizedBox(height: 8),
                // Mobile Number
                Text(
              'Mobile Number(*)',
                  style:  TextStyle(
                    fontSize: 17.w,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
               e. CustomTextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  hintText:'Enter Mobile Number',
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

                const SizedBox(height: 24),
            SizedBox(
              height: height * .05,
              child: GestureDetector(
                onTap: (){
                  if(_emailController.text.isEmpty||_mobileController.text.isEmpty||_nameController.text.isEmpty){
                    showErrorAlert('PLease fill all fields',context,);

                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.center,
                  child:Text("Register",style: TextStyle(fontWeight: FontWeight.bold),))),
            )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
