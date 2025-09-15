import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/model/car_category.dart';
import '../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../controller/ads/data_layer.dart';
import '../../../controller/const/colors.dart';
import '../../widgets/ads/create_ad_widgets/form_fields_section.dart';
import '../../widgets/ads/create_ad_widgets/image_upload_section.dart';
import '../../widgets/ads/create_ad_widgets/validation_methods.dart';
import '../../widgets/ads/dialogs/error_dialog.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/ads/dialogs/missing_fields_dialog.dart';
import '../../widgets/ads/dialogs/success_dialog.dart';
import '../../widgets/ads/dialogs/missing_cover_image_dialog.dart';
import '../../widgets/ads/create_ad_widgets/ad_submission_service.dart';


class SellCarScreen extends StatefulWidget {
  final dynamic postData;

  SellCarScreen({this.postData});

  @override
  _SellCarScreenState createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  List<String> _images = [];
  String? _coverImage;
  String? _videoPath;

  // Store listener references
  VoidCallback? _makeListener;
  VoidCallback? _classListener;

  // Track previous values to detect actual clearing vs value changes
  String _previousMakeValue = '';
  String _previousClassValue = '';


  String? selectedMake;
  String? selectedModel;
  String? selectedType;
  String? selectedYear;
  String? selectedTrim;
  String? selectedClass;
  String? selectedunderWarranty;
  Color _exteriorColor = const Color(0xffd54245);
  Color _interiorColor = const Color(0xff4242d4);
  bool _termsAccepted = false;
  bool _infoConfirmed = false;

  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _exteriorColorController = TextEditingController();
  final TextEditingController _interiorColorController = TextEditingController();
  final TextEditingController _askingPriceController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  final TextEditingController _minimumPriceController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();

  //new controllers
  final TextEditingController _make_contrller = TextEditingController();
  final TextEditingController _model_controller = TextEditingController();
  final TextEditingController _class_controller = TextEditingController();
  final TextEditingController _type_controller = TextEditingController();
  final TextEditingController _year_controller = TextEditingController();
  final TextEditingController _warranty_controller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final AdCleanController brandController = Get.put(
    AdCleanController(AdRepository()),
  );
  void _handleImageSelected(String imagePath) {
    setState(() {
      _images.add(imagePath);
      // If this is the first image, set it as cover
      if (_images.length == 1 && _coverImage == null) {
        _coverImage = imagePath;
      }
    });
  }

  void _handleVideoSelected(String videoPath) {
   log('Video selected: $videoPath');
    setState(() {
      _videoPath = videoPath;
      // Only set as cover if there are no other covers and no images
      if (_coverImage == null && _images.isEmpty) {
        _coverImage = videoPath;
      }
     log('Video added. Cover image: $_coverImage');
    });
  }

  void _handleCoverChanged(String? imagePath) {
    if (imagePath != null) {
      setState(() {
        _coverImage = imagePath;
      });
    }
  }

  void _handleImageRemoved(int index) {
    setState(() {
      if (index >= 0 && index < _images.length) {
        String removedImage = _images[index];
        _images.removeAt(index);

        // If we removed the cover image
        if (_coverImage == removedImage) {
          _coverImage = _images.isNotEmpty
              ? _images[0]
              : (_videoPath != null ? _videoPath : null);
        }
      }
      // If we're removing the video
      else if (index == -1 && _videoPath != null) {
        // If the current cover is the video, update it
        if (_coverImage == _videoPath) {
          _coverImage = _images.isNotEmpty ? _images[0] : null;
        }
        _videoPath = null;
      }
    });
  }

  void _populateFieldsFromPostData(dynamic postData) {
    log(' _populateFieldsFromPostData called with data: $postData');
    
    setState(() {
      // Populate car details from API response
      selectedMake = postData['Make_Name_PL'] ;
      selectedModel = postData['Model_Name_PL']?.toString();
      selectedYear = postData['Manufacture_Year']?.toString();
      selectedClass = postData['Class_Name_PL']?.toString();
      selectedType = ""; // Default or get from post data if available
      
      log(' selectedMake: $selectedMake');
     log(' selectedModel: $selectedModel');
    log(' selectedYear: $selectedYear');
     log(' selectedClass: $selectedClass');
      
      // Populate text controllers with correct API field names
      _mileageController.text = postData['Mileage']?.toString() ?? '';
      _plateNumberController.text = postData['Plate_Number'] ?? '';
      _chassisNumberController.text = postData['Chassis_Number'] ?? '';
      _askingPriceController.text = postData['Asking_Price'] ?? '';
      _minimumPriceController.text = postData['Minimum_Price'] ?? '';
      
      // Populate colors with correct API field names
      if (postData['Color_Exterior'] != null) {
        _exteriorColor = Color(int.parse(postData['Color_Exterior'].replaceFirst('#', '0xFF')));
      }
      if (postData['Color_Interior'] != null) {
        _interiorColor = Color(int.parse(postData['Color_Interior'].replaceFirst('#', '0xFF')));
      }
      
      // Populate warranty with correct API field name
      selectedunderWarranty = (postData['Warranty_isAvailable']?.toString() == '1' || postData['Warranty_isAvailable'] == 1) ? "Yes" : "No";
      
      // Populate description with correct API field names
      _descriptionController.text = postData['Technical_Description_PL'] ?? postData['Technical_Description_SL'] ?? '';
      
      // Populate other controllers directly from post data with correct field names
      _make_contrller.text = postData['Make_Name_PL'] ?? postData['Make_Name_PL'] ?? '';
      _model_controller.text = postData['Model_Name_PL']?.toString() ?? '';
      _class_controller.text = postData['Class_Name_PL']?.toString() ?? '';
      _year_controller.text = postData['Manufacture_Year']?.toString() ?? '';
      _warranty_controller.text = (postData['Warranty_isAvailable']?.toString() == '1' || postData['Warranty_isAvailable'] == 1) ? "Yes" : "No";

      // Set the type controller directly
// Set the type controller directly
_type_controller.text = postData['Category_Name_PL']?.toString() ??
    (brandController.carCategories.isNotEmpty
        ? brandController.carCategories.last.name
        : "4*4");//k
      
      // Load existing image if available
      if (postData['Rectangle_Image_URL'] != null) {
        _coverImage = postData['Rectangle_Image_URL'];
      }
      
      log(' _make_contrller.text: ${_make_contrller.text}');
      log(' _model_controller.text: ${_model_controller.text}');
      log(' _year_controller.text: ${_year_controller.text}');
      log(' _warranty_controller.text: ${_warranty_controller.text}');
      log(' _coverImage: $_coverImage');
    });
  }

  @override
  void initState() {
    super.initState();
    
    // If we have post data, populate the fields first (editing existing ad)
    if (widget.postData != null) {
      _populateFieldsFromPostData(widget.postData!);
    } else {
      // New ad creation - clear all controllers and set defaults
      _make_contrller.clear();
      _model_controller.clear();
      _class_controller.clear();
      _mileageController.clear();
      _plateNumberController.clear();
      _chassisNumberController.clear();
      _askingPriceController.clear();
      _minimumPriceController.clear();
      _descriptionController.clear();
      _exteriorColorController.clear();
      _interiorColorController.clear();
      
      // Set year to most recent year
      _year_controller.text = (DateTime.now().year + 1).toString();
      
      // Set warranty default to "No"
      _warranty_controller.text = "No";
      
      // Wait for categories to load and set type to first category
      ever(brandController.carCategories, (List<CarCategory> categories) {
        if (categories.isNotEmpty) {//m
          log('Categories loaded in ever(), count: ${categories.length}');
          log('First category: ${categories.last.name}');
          _type_controller.text = categories.last.name;
          brandController.selectedCategory.value = categories.first;
          log('Type controller set to: ${_type_controller.text}');
        }
      });
      
      // Also listen to loading state
      ever(brandController.isLoadingCategories, (bool isLoading) {
        if (!isLoading && brandController.carCategories.isNotEmpty) {
          log('Categories finished loading, setting first category');
          _type_controller.text = brandController.carCategories.last.name;
          brandController.selectedCategory.value = brandController.carCategories.last;
        }
      });
      
      // Set initial type if categories are already loaded
      if (brandController.carCategories.isNotEmpty) {
        _type_controller.text = brandController.carCategories.last.name;
        brandController.selectedCategory.value = brandController.carCategories.last;
        log('Initial type set to: ${brandController.carCategories.last.name}');
      } else {
        _type_controller.clear(); // Clear until categories load
        log('Waiting for categories to load...');
      }
      
      // Add a delayed check as a fallback
      Future.delayed(Duration(seconds: 2), () {
        if (mounted && brandController.carCategories.isNotEmpty && _type_controller.text.isEmpty) {
          log('Fallback: Setting type after delay');
          _type_controller.text = brandController.carCategories.first.name;
          brandController.selectedCategory.value = brandController.carCategories.first;
        }
      });
    }

    // Add listener to make controller to clear class and model when make is cleared
    _makeListener = () {
      // Only clear if the controller was previously not empty and now is empty
      if (_make_contrller.text.isEmpty && _previousMakeValue.isNotEmpty) {
        // Clear class and model when make is cleared
        _class_controller.clear();
        brandController.selectedClass.value = null;
        brandController.carClasses.clear();
        _model_controller.clear();
        brandController.selectedModel.value = null;
        brandController.carModels.clear();
        setState(() {});
      }
      // Update previous value
      _previousMakeValue = _make_contrller.text;
    };
    _make_contrller.addListener(_makeListener!);

    // Add listener to class controller to clear model when class is cleared
    _classListener = () {
      // Only clear if the controller was previously not empty and now is empty
      if (_class_controller.text.isEmpty && _previousClassValue.isNotEmpty) {
        // Clear model when class is cleared
        _model_controller.clear();
        brandController.selectedModel.value = null;
        brandController.carModels.clear();
        setState(() {});
      }
      // Update previous value
      _previousClassValue = _class_controller.text;
    };
    _class_controller.addListener(_classListener!);
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _exteriorColorController.dispose();
    _interiorColorController.dispose();
    _askingPriceController.dispose();
    _descriptionController.dispose();

    _chassisNumberController.dispose();
    _plateNumberController.dispose();
    // Remove listeners before disposing controllers
    if (_makeListener != null) {
      _make_contrller.removeListener(_makeListener!);
    }
    if (_classListener != null) {
      _class_controller.removeListener(_classListener!);
    }

    _make_contrller.dispose();
    _model_controller.dispose();
    _class_controller.dispose();
    _type_controller.dispose();
    _year_controller.dispose();
    _warranty_controller.dispose();
    super.dispose();
  }

  /// Validate form and submit ad
  void _validateAndSubmitForm() {
    // Validate form using validation methods
    bool isValid = ValidationMethods.validateForm(
      make: _make_contrller.text,
      carClass: _class_controller.text,
      model: _model_controller.text,
      type: _type_controller.text,
      year: _year_controller.text,
      askingPrice: _askingPriceController.text,
      mileage: _mileageController.text,
      description: _descriptionController.text,
      coverImage: _coverImage ?? '',
      termsAccepted: _termsAccepted,
      infoConfirmed: _infoConfirmed,
      context: context,
      showMissingFieldsDialog: _showMissingFieldsAlert,
      showMissingCoverImageDialog: _showMissingCoverImageAlert,
    );

    if (!isValid) return;

    // Validate numeric fields
    bool numericValid = ValidationMethods.validateNumericFields(
      askingPrice: _askingPriceController.text,
      minimumPrice: _minimumPriceController.text,
      mileage: _mileageController.text,
      plateNumber: _plateNumberController.text,
      chassisNumber: _chassisNumberController.text,
      context: context,
      showErrorDialog: _showErrorAlert,
    );

    if (!numericValid) return;

    // Validate manufacture year
    bool yearValid = ValidationMethods.validateManufactureYear(
      year: _year_controller.text,
      context: context,
      showErrorDialog: _showErrorAlert,
    );

    if (!yearValid) return;

    // Submit the ad using the service
    _submitAd();
  }

  /// Show alert for missing fields
  void _showMissingFieldsAlert(String message) {
    MissingFieldsDialog.show(context, [message]);
  }

  /// Show alert for missing cover image
  void _showMissingCoverImageAlert() {
    MissingCoverImageDialog.show(context);
  }

  /// Show loading dialog
  void _showLoadingDialog() {
    LoadingDialog.show(context);
  }

  /// Hide loading dialog
  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Show success dialog
  void _showSuccessDialog(String message, String postId) {
    SuccessDialog.show(
      context,
      postId,
          () {
        Navigator.pop(context); // Navigate back from create ad screen
        brandController.resetCreateAdState(); // Reset controller state
      },
    );
  }

  /// Show error dialog
  void _showErrorAlert(String message) {
    ErrorDialog.show(
      context,
      message,
          () {
        brandController.resetCreateAdState(); // Reset controller state
      },
    );
  }

  /// Submit ad to API
  void _submitAd() async {
    // Log the submission
    AdSubmissionService.logAdSubmission(
      make: _make_contrller.text,
      carClass: _class_controller.text,
      model: _model_controller.text,
      type: _type_controller.text,
      year: _year_controller.text,
      askingPrice: _askingPriceController.text,
      imageCount: _images.length,
      hasVideo: _videoPath != null && _videoPath!.isNotEmpty,
    );

    // Submit the ad using the service
    await AdSubmissionService.submitAd(
      context: context,
      images: _images,
      coverImage: _coverImage ?? '',
      videoPath: _videoPath,
      make: _make_contrller.text,
      carClass: _class_controller.text,
      model: _model_controller.text,
      type: _type_controller.text,
      year: _year_controller.text,
      warranty: _warranty_controller.text,
      askingPrice: _askingPriceController.text,
      minimumPrice: _minimumPriceController.text,
      mileage: _mileageController.text,
      plateNumber: _plateNumberController.text,
      chassisNumber: _chassisNumberController.text,
      description: _descriptionController.text,
      exteriorColor: _exteriorColor,
      interiorColor: _interiorColor,
      showLoadingDialog: _showLoadingDialog,
      showSuccessDialog: _showSuccessDialog,
      showErrorDialog: _showErrorAlert,
      hideLoadingDialog: _hideLoadingDialog,
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.background,
          toolbarHeight: 60.h,
          shadowColor: Colors.grey.shade300,

          elevation: .4,

          title: Text(
            "Sell Your Car",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Upload Section
                    ImageUploadSection(
                      images: _images,
                      coverImage: _coverImage,
                      videoPath: _videoPath,
                      onImageSelected: _handleImageSelected,
                      onVideoSelected: _handleVideoSelected,
                      onCoverChanged: _handleCoverChanged,
                      onImageRemoved: (index) => _handleImageRemoved(index),
                    ),

                    // Form Fields Section
                    FormFieldsSection(
                      makeController: _make_contrller,
                      classController: _class_controller,
                      modelController: _model_controller,
                      typeController: _type_controller,
                      yearController: _year_controller,
                      warrantyController: _warranty_controller,
                      askingPriceController: _askingPriceController,
                      minimumPriceController: _minimumPriceController,
                      mileageController: _mileageController,
                      plateNumberController: _plateNumberController,
                      chassisNumberController: _chassisNumberController,
                      descriptionController: _descriptionController,
                      exteriorColor: _exteriorColor,
                      interiorColor: _interiorColor,
                      onExteriorColorSelected: (color) {
                        setState(() {
                          _exteriorColor = color;
                         log(color.hashCode.toString());
                        });
                      },
                      onInteriorColorSelected: (color) {
                        setState(() {
                          _interiorColor = color;
                          log(color.hashCode.toString());
                        });
                      },
                      termsAccepted: _termsAccepted,
                      infoConfirmed: _infoConfirmed,
                      onTermsChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _termsAccepted = value;
                          });
                        }
                      },
                      onInfoChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _infoConfirmed = value;
                          });
                        }
                      },
                      onValidateAndSubmit: _validateAndSubmitForm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}