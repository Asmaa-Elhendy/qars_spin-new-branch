import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/model/car_category.dart';
import '../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../controller/ads/data_layer.dart';
import '../../../controller/const/colors.dart';
import '../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../widgets/ads/create_ad_widgets/form_fields_section.dart';
import '../../widgets/ads/create_ad_widgets/image_upload_section.dart';
import '../../widgets/ads/create_ad_widgets/validation_methods.dart';
import '../../widgets/ads/dialogs/error_dialog.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/ads/dialogs/missing_fields_dialog.dart';
import '../../widgets/ads/dialogs/missing_cover_image_dialog.dart';
import '../../widgets/ads/dialogs/success_dialog.dart';
import '../../widgets/ads/create_ad_widgets/ad_submission_service.dart';
import '../../screens/my_ads/my_ads_main_screen.dart';


class SellCarScreen extends StatefulWidget {
  final dynamic postData;

  SellCarScreen({this.postData});

  @override
  _SellCarScreenState createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  List<String> _images = [];
  String? _coverImage;//jk
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
  String? selectedClass;
  String? selectedunderWarranty;
  
  // Loading state for modify mode
  bool _isLoadingModifyData = false;

  Color? _exteriorColor;
  Color? _interiorColor;
  bool _termsAccepted = false;
  bool _infoConfirmed = false;

  String? _originalExteriorColorHex;
  String? _originalInteriorColorHex;

  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _exteriorColorController = TextEditingController();
  final TextEditingController _interiorColorController = TextEditingController();
  final TextEditingController _askingPriceController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  final TextEditingController _minimumPriceController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();

  //new controllers
  final TextEditingController _make_controller = TextEditingController();
  final TextEditingController _model_controller = TextEditingController();
  final TextEditingController _class_controller = TextEditingController();
  final TextEditingController _type_controller = TextEditingController();
  final TextEditingController _year_controller = TextEditingController();
  final TextEditingController _warranty_controller = TextEditingController();
  final TextEditingController request360Controller = TextEditingController();
  final TextEditingController requestFeatureController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  bool _coverPhotoChanged = false;
  bool _videoChanged = false;

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
      _videoChanged = true; // Mark video as changed
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

      selectedMake = postData['Make_Name_PL'];
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


      
      if (postData['Color_Exterior'] != null) {
        _exteriorColor = Color(int.parse(postData['Color_Exterior'].replaceFirst('#', '0xFF')));
        _originalExteriorColorHex = postData['Color_Exterior'];
        log('✅ Exterior color parsed: $_exteriorColor from ${postData['Color_Exterior']}');
      } else {
        log('❌ Color_Exterior is null in postData');
      }

      if (postData['Color_Interior'] != null) {
        _interiorColor = Color(int.parse(postData['Color_Interior'].replaceFirst('#', '0xFF')));
        _originalInteriorColorHex = postData['Color_Interior'];
        log('✅ Interior color parsed: $_interiorColor from ${postData['Color_Interior']}');
      } else {
        log('❌ Color_Interior is null in postData');
      }



      // Populate warranty with correct API field name
      selectedunderWarranty = (postData['Warranty_isAvailable']?.toString() == '1' || postData['Warranty_isAvailable'] == 1) ? "Yes" : "No";

      // Populate description with correct API field names
      _descriptionController.text = postData['Technical_Description_PL'] ?? postData['Technical_Description_SL'] ?? '';

      // Populate other controllers directly from post data with correct field names
      _make_controller.text = postData['Make_Name_PL'] ?? postData['Make_Name_PL'] ?? '';
      _model_controller.text = postData['Model_Name_PL']?.toString() ?? '';
      _class_controller.text = postData['Class_Name_PL']?.toString() ?? '';
      _year_controller.text = postData['Manufacture_Year']?.toString() ?? '';
      _warranty_controller.text = (postData['Warranty_isAvailable']?.toString() == '1' || postData['Warranty_isAvailable'] == 1) ? "Yes" : "No";

      // Set the type controller directly from post data (for modify mode)
      _type_controller.text = postData['Category_Name_PL']?.toString() ?? '';

      // Find the matching category in the list and set it
      if (_type_controller.text.isNotEmpty) {
        final matchingCategory = brandController.carCategories.firstWhereOrNull(
          (c) => c.name == _type_controller.text,
        );
        if (matchingCategory != null) {
          brandController.selectedCategory.value = matchingCategory;
          log('Category set from post data: ${matchingCategory.name}');
        } else {
          // If category from post data not found in list, keep the text but clear selected cateigory
          brandController.selectedCategory.value = null;
          log('Category from post data not found in list: ${_type_controller.text}');
        }
      } else {
        // Keep empty if post data has empty category
        brandController.selectedCategory.value = null;
        log('Category kept empty as per post data');
      }

      // Load existing image if available
      if (postData['Rectangle_Image_URL'] != null) {
        setState(() {
          _coverImage = postData['Rectangle_Image_URL'];
          
          // Also add it as the first item in the images list for modify mode
          if (_images.isEmpty) {
            _images.add(postData['Rectangle_Image_URL']);
          } else {
            // If list has items, insert at the beginning
            _images.insert(0, postData['Rectangle_Image_URL']);
          }
        });

        log('Cover image set to: $_coverImage');
        log('Images list updated with Rectangle_Image_URL as first item: $_images');
      }

      // Load gallery images if available
      if (postData['Gallery_Photos'] != null) {
        List<dynamic> galleryPhotos = postData['Gallery_Photos'];
        setState(() {
          for (var photo in galleryPhotos) {
            String photoUrl = photo.toString();
            // Don't add the cover image again if it's already in the gallery
            if (photoUrl != postData['Rectangle_Image_URL'] && !_images.contains(photoUrl)) {
              _images.add(photoUrl);
            }
          }
        });
        log('Gallery images loaded: ${_images.length} total images');
      }

      // Load video if available
      if (postData['Video_URL'] != null) {
        setState(() {
          _videoPath = postData['Video_URL'];
        });
        log('Video loaded: $_videoPath');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    request360Controller.text='No';
    requestFeatureController.text='No';
    // Check if we're in modify mode with post ID
    if (widget.postData != null && widget.postData['isModifyMode'] == true) {
      // Load post data in the background
      _loadPostDataForModify();
    } else if (widget.postData != null) {
      // If we have complete post data, populate the fields (existing behavior)
      _populateFieldsFromPostData(widget.postData!);
    } else {
      // Initialize for new ad
      _initializeForNewAd();
    }

    // Add listener to make controller to clear class and model when make is cleared
    _makeListener = () {
      // Only clear if the controller was previously not empty and now is empty
      if (_make_controller.text.isEmpty && _previousMakeValue.isNotEmpty) {
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
      _previousMakeValue = _make_controller.text;
    };
    _make_controller.addListener(_makeListener!);

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

  Future<void> _loadPostDataForModify() async {
    final postId = widget.postData?['postId']?.toString();
    final postKind = widget.postData?['postKind'] ?? 'CarForSale';

    if (postId == null) return;

    log('🔍 Starting to load post data for modify mode...');

    // Show loading indicator
    setState(() {
      _isLoadingModifyData = true;
      log('🔍 Loader state set to true');
    });

    // Add a longer delay to ensure the loader is visible
    // await Future.delayed(Duration(milliseconds: 1000));
    // log('🔍 Delay completed, starting API call');

    try {
      // Get the controller and fetch post details
      final myAdController = Get.find<MyAdCleanController>();

      await myAdController.getPostById(
        postKind: postKind,
        postId: postId,
        loggedInUser: widget.postData?['userName'] ?? '', // Get username from postData
      );

      // Check if we got the data successfully
      if (myAdController.postDetails.value != null) {
        log('🔍 Post data loaded successfully for modify mode');
        log('🔍 postDetails.value: ${myAdController.postDetails.value}');

        // Populate the fields with the loaded data
        if (mounted) {
          _populateFieldsFromPostData(myAdController.postDetails.value!);
        }
      } else {
        // Show error message
        if (mounted) {
          Get.snackbar(
            'Error',
            myAdController.postDetailsError.value ?? 'Failed to load post data',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to load post data: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isLoadingModifyData = false;
          log('🔍 Loader state set to false');
        });
      }
    }
  }

  void _initializeForNewAd() {
    // New ad creation - clear all controllers and set defaults
    _make_controller.clear();
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

    // Wait for categories to load and set type to last category (for new ads only)
    ever(brandController.carCategories, (List<CarCategory> categories) {
      if (categories.isNotEmpty && widget.postData == null) {
        // Only set default for new ads (when postData is null)
        log('Categories loaded in ever() for new ad, count: ${categories.length}');
        log('Last category: ${categories.last.name}');
        _type_controller.text = categories.last.name;
        brandController.selectedCategory.value = categories.last;
        log('Type controller set to: ${_type_controller.text}');
      }
    });

    // Also listen to loading state
    ever(brandController.isLoadingCategories, (bool isLoading) {
      if (!isLoading && brandController.carCategories.isNotEmpty && widget.postData == null) {
        // Only set default for new ads (when postData is null)
        log('Categories finished loading, setting last category for new ad');
        _type_controller.text = brandController.carCategories.last.name;
        brandController.selectedCategory.value = brandController.carCategories.last;
      }
    });

    // Set initial type if categories are already loaded (for new ads only)
    if (brandController.carCategories.isNotEmpty && widget.postData == null) {
      _type_controller.text = brandController.carCategories.last.name;
      brandController.selectedCategory.value = brandController.carCategories.last;
      log('Initial type set to: ${brandController.carCategories.last.name}');
    } else if (widget.postData == null) {
      _type_controller.clear(); // Clear until categories load for new ads
      log('Waiting for categories to load...');
    }

    // Add a delayed check as a fallback (for new ads only)
    Future.delayed(Duration(seconds: 2), () {
      if (mounted && brandController.carCategories.isNotEmpty && _type_controller.text.isEmpty && widget.postData == null) {
        log('Fallback: Setting type after delay for new ad');
        _type_controller.text = brandController.carCategories.last.name;
        brandController.selectedCategory.value = brandController.carCategories.last;
      }
    });

    // Set default colors for new ads
    if (widget.postData == null) {
      _exteriorColor = const Color(0xffd54245);
      _interiorColor = const Color(0xff4242d4);
    }
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
      _make_controller.removeListener(_makeListener!);
    }
    if (_classListener != null) {
      _class_controller.removeListener(_classListener!);
    }

    _make_controller.dispose();
    _model_controller.dispose();
    _class_controller.dispose();
    _type_controller.dispose();
    _year_controller.dispose();
    _warranty_controller.dispose();
    super.dispose();
  }

  /// Validate form and submit ad
  void _validateAndSubmitForm({bool shouldPublish = false}) {
    // Validate form using validation methods
    bool isValid = ValidationMethods.validateForm(
      postData:widget.postData,
      make: _make_controller.text,
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
    _submitAd(shouldPublish: shouldPublish);
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
    LoadingDialog.show(context, isModifyMode: widget.postData != null);
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
      _navigateToMyAds,
      isModifyMode: widget.postData != null,
    );
  }

  /// Show error dialog
  void _showErrorAlert(String message) {
    ErrorDialog.show(
      context,
      message,
      () {
        Navigator.pop(context);
      },
      isModifyMode: widget.postData != null,
    );
  }

  /// Navigate to MyAds screen
  void _navigateToMyAds() {
    // Use Get.offAll to ensure we always navigate to MyAds screen
    // This works for both create and modify flows
    Get.offAll(() => const MyAdsMainScreen());
    Get.find<MyAdCleanController>().fetchMyAds(); // Refresh My Ads screen
    brandController.resetCreateAdState(); // Reset controller state
  }

  /// Unfocus description field to prevent auto-focus
  void _unfocusDescription() {
    FocusScope.of(context).unfocus();
  }

  /// Submit ad to API
  void _submitAd({bool shouldPublish = false}) async {
    // Log the submission
    AdSubmissionService.logAdSubmission(
      make: _make_controller.text,
      carClass: _class_controller.text,
      model: _model_controller.text,
      type: _type_controller.text,
      year: _year_controller.text,
      askingPrice: _askingPriceController.text,
      imageCount: _images.length,
      hasVideo: _videoPath != null && _videoPath!.isNotEmpty,
    );

    // Check if we're in modify mode
    final String? postId = widget.postData?['ID']?.toString() ?? widget.postData?['postId']?.toString();

    if (postId != null && postId.isNotEmpty) {
      // Update mode
      await AdSubmissionService.updateAd(
        context: context,
        images: _images,
        coverImage: _coverImage ?? '',
        videoPath: _videoPath,
        make: _make_controller.text,
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
        exteriorColor: _exteriorColor ?? Colors.white,
        interiorColor: _interiorColor ?? Colors.white,
        postId: postId,
        coverPhotoChanged: _coverPhotoChanged,
        videoChanged: _videoChanged,
        shouldPublish: shouldPublish,
        showLoadingDialog: _showLoadingDialog,
        showSuccessDialog: _showSuccessDialog,
        showErrorDialog: _showErrorAlert,
        hideLoadingDialog: _hideLoadingDialog,
      );
    } else {
      // Create mode
      await AdSubmissionService.submitAd(
        request360controller: request360Controller,
        featureyouradcontroller: requestFeatureController,
        shouldPublish: shouldPublish,
        context: context,
        images: _images,
        coverImage: _coverImage ?? '',
        videoPath: _videoPath,
        make: _make_controller.text,
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
        exteriorColor: _exteriorColor ?? Colors.white,
        interiorColor: _interiorColor ?? Colors.white,
        videoChanged: _videoChanged,
        showLoadingDialog: _showLoadingDialog,
        showSuccessDialog: _showSuccessDialog,
        showErrorDialog: _showErrorAlert,
        hideLoadingDialog: _hideLoadingDialog,
        navigateToMyAds: _navigateToMyAds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();

        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          toolbarHeight: 60.h,
          shadowColor: Colors.grey.shade300,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5.h,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          elevation: 0, // نشيل الشادو الافتراضي

          title: Text(
            widget.postData != null ? "Modify Car" : "Sell Your Car",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Main content
            SingleChildScrollView(
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
                          isModifyMode: widget.postData != null,
                          onCoverPhotoChanged: (bool changed) {
                            setState(() {
                              _coverPhotoChanged = changed;
                            });
                          },
                          onVideoChanged: (bool changed) {
                            setState(() {
                              _videoChanged = changed;
                            });
                          },
                        ),

                        // // Form Fields Section - Debug logs
                        // Builder(
                        //   builder: (context) {
                        //     log('🎨 Passing colors to FormFieldsSection:');
                        //     log('🎨 _exteriorColor: $_exteriorColor');
                        //     log('🎨 _interiorColor: $_interiorColor');
                        //     log('🎨 exteriorColor parameter: ${_exteriorColor ?? Colors.white}');
                        //     log('🎨 interiorColor parameter: ${_interiorColor ?? Colors.white}');
                        //     return SizedBox.shrink(); // Return empty widget
                        //   },
                        // ),

                        FormFieldsSection(postData: widget.postData,
                          request360Controller: request360Controller,
                          requestFeatureController:requestFeatureController ,
                          makeController: _make_controller,
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
                          exteriorColor: _exteriorColor ?? Colors.white,
                          interiorColor: _interiorColor ?? Colors.white,
                          onExteriorColorSelected: (color) {
                            setState(() {//kتن
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
                          onUnfocusDescription: _unfocusDescription,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading overlay for modify mode
            if (_isLoadingModifyData)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: AppLoadingWidget(
                    title: 'Loading car data...',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}