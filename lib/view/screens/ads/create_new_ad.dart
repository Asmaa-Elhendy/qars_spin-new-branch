import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../controller/ads/data_layer.dart';
import '../../../controller/const/colors.dart';
import '../../widgets/ads/color_picker_field.dart';
import '../../widgets/ads/drop_Down_field.dart';
import '../../widgets/ads/image_picker_field.dart';
import '../../widgets/ads/text_field.dart';
import '../../widgets/ads/video_player_widget.dart';

class SellCarScreen extends StatefulWidget {
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

  bool _isVideo(String path) {
    if (path.isEmpty) return false;

    // Trim any query parameters or fragments from the path
    final cleanPath = path.split('?').first.split('#').first;

    // Get the file extension without the dot
    final fileName = cleanPath.split('/').last;
    if (!fileName.contains('.')) return false;

    final ext = fileName.split('.').last.toLowerCase().trim();

    // Common video extensions
    const videoExtensions = {
      'mp4',
      'mov',
      'avi',
      'mkv',
      'webm',
      'wmv',
      'flv',
      '3gp',
      'm4v',
    };

    final isVideo = videoExtensions.contains(ext);
    debugPrint('''
    Video Check:
    - Original path: $path
    - Cleaned path: $cleanPath
    - File name: $fileName
    - Extracted extension: $ext
    - Is video: $isVideo
    ''');

    return isVideo;
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.photo, size: 50, color: Colors.grey[400]),
      ),
    );
  }

  String? selectedMake;
  String? selectedModel;
  String? selectedType = "4*4";
  String? selectedYear;
  String? selectedTrim;
  String? selectedClass;
  String? selectedunderWarranty;
  Color _exteriorColor = Color(0xffd54245);
  Color _interiorColor = Color(0xff4242d4);
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
    debugPrint('Video selected: $videoPath');
    setState(() {
      _videoPath = videoPath;
      // Only set as cover if there are no other covers and no images
      if (_coverImage == null && _images.isEmpty) {
        _coverImage = videoPath;
      }
      debugPrint('Video added. Cover image: $_coverImage');
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

  @override
  void initState() {
    super.initState();
    // Set default value for type controller
    _type_controller.text = selectedType ?? "4*4";

    // Set default value for year controller to first year (current year + 1)
    _year_controller.text = selectedYear ?? (DateTime.now().year + 1).toString();

    // Set default value for warranty controller
    _warranty_controller.text = selectedunderWarranty ?? "No";

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * .01),
                    child: Center(
                      child: Text(
                        "Upload Your up to 15 Photos and 1 Video ",
                        style: TextStyle(
                          fontSize: width * .03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Cover Image Preview
                  if (_coverImage != null && _coverImage!.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: height * .35,
                          child: _isVideo(_coverImage!)
                              ? VideoPlayerWidget(
                            videoPath: _coverImage!,
                            autoPlay: true,
                            looping: true,
                          )
                              : Image.file(
                            File(_coverImage!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          ),
                        ),
                        SizedBox(height: height * .02),
                      ],
                    ),
                  ImagePickerField(
                    imagePaths: _images,
                    coverImage: _coverImage,
                    videoPath: _videoPath,
                    maxImages: 15,
                    onImageSelected: _handleImageSelected,
                    onVideoSelected: _handleVideoSelected,
                    onCoverChanged: _handleCoverChanged,
                    onImageRemoved: _handleImageRemoved,
                  ),

                  SizedBox(height: height * .02),

                  Text(
                    "(*) Mandatory Choice",
                    style: TextStyle(fontSize: width * .04),
                  ),
                  SizedBox(height: height * .01),


                  // Make Dropdown
                  Obx(() => CustomDropDownTyping(
                    label: "Choose Make(*)",
                    controller: _make_contrller,
                    options: brandController.carBrands
                        .map((b) => b.name)
                        .toList()
                      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                    onChanged: (value) {
                      final selected = brandController.carBrands
                          .firstWhereOrNull((b) => b.name == value);

                      if (selected != null) {
                        brandController.selectedMake.value = selected;
                        _make_contrller.text = selected.name; // still keep controller in sync
                        log("heee   ${_make_contrller.text}");
                        brandController.fetchCarClasses(selected.id.toString());
                        _class_controller.clear();
                        brandController.selectedClass.value = null;
                        // Force immediate UI refresh
                        setState(() {});
                      } else if (value.isEmpty) {
                        // Clear class and model fields when make is cleared
                        _class_controller.clear();
                        brandController.selectedClass.value = null;
                        brandController.carClasses.clear();
                        _model_controller.clear();
                        brandController.selectedModel.value = null;
                        brandController.carModels.clear();
                        // Force immediate UI refresh
                        setState(() {});
                      }
                    },
                  ))


                  // DropdownField(
                  //   value: selectedMake,
                  //   label: "Choose Make(*)",
                  //   items: ["Toyota", "Honda", "BMW", "Mercedes"],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedMake = value;
                  //     });
                  //   },
                  // ),
                  ,SizedBox(height: height * .01),
                  // Class Dropdown
                  Obx(() {
                    return CustomDropDownTyping(
                      label: "Choose Class(*)",
                      controller: _class_controller,
                      options: brandController.carClasses.map((c) => c.name).toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                      onChanged: (value) {
                        final selected = brandController.carClasses
                            .firstWhereOrNull((c) => c.name == value);
                        if (selected != null) {
                          brandController.selectedClass.value = selected;
                          brandController.fetchCarModels(selected.id.toString());
                          _model_controller.clear();
                          brandController.selectedModel.value = null;
                          setState(() {});
                        } else if (value.isEmpty) {
                          _model_controller.clear();
                          brandController.selectedModel.value = null;
                          brandController.carModels.clear();
                          setState(() {});
                        }
                      },
                    );
                  }),

                  // DropdownField(
                  //   value: selectedClass,
                  //   label: "Choose Class(*)",
                  //   items: ["Toyota", "Honda", "BMW", "Mercedes"],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedClass = value;
                  //     });
                  //   },
                  // ),
                  SizedBox(height: height * .01),
                  // Model Dropdown
                  Obx(() {
                    return CustomDropDownTyping(
                      label: "Choose Model(*)",
                      controller: _model_controller,
                      options: brandController.carModels.map((m) => m.name).toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                      onChanged: (value) {
                        final selected = brandController.carModels
                            .firstWhereOrNull((m) => m.name == value);
                        if (selected != null) {
                          brandController.selectedModel.value = selected;
                        }
                      },
                    );
                  }),

                  // Model Dropdown
                  // DropdownField(
                  //   value: selectedModel,
                  //   label: "Choose Model(*)",
                  //   items: ["Camry", "Corolla", "RAV4", "Highlander"],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedModel = value;
                  //     });
                  //   },
                  // ),
                  SizedBox(height: height * .01),
                  CustomDropDownTyping(
                    label: "Choose Type(*)",
                    controller: _type_controller,
                    options: ["4*4", "Bus", "Convertible", "Coupe", "CrossOver", "Electric Vehicle (EV)"],
                    enableSearch: false,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),

                  SizedBox(height: height * .01),
                  // Year Dropdown
                  CustomDropDownTyping(
                    label: "Manufacture Year(*)",
                    controller: _year_controller,
                    options: List.generate(
                      51,
                          (index) => (DateTime.now().year + 1 - index).toString(),
                    ).toList(),
                    enableSearch: false,
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  ),

                  SizedBox(height: height * .01),

                  // Under Warranty Dropdown


                  SizedBox(height: height * .01),

                  // Mileage Text Field
                  CustomTextField(
                    fromCreateAd: true,
                    controller: _askingPriceController,
                    label: "Asking Price(*)",
                    keyboardType: TextInputType.number,
                    cursorColor: AppColors.brandBlue,
                    cursorHeight: 25.h,
                  ),
                  SizedBox(height: height * .01),

                  // Mileage Text Field
                  CustomTextField(
                    fromCreateAd: true,
                    controller: _minimumPriceController,
                    label: "Minimum biding price yoou want to see",
                    keyboardType: TextInputType.number,   cursorColor: AppColors.brandBlue,
                    cursorHeight: 25.h,
                  ),
                  SizedBox(height: height * .01),

                  // Mileage Text Field
                  CustomTextField(
                    fromCreateAd: true,
                    controller: _mileageController,
                    label: "Mileage(*)",
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: height * .01),

                  // Exterior Color Picker
                  ColorPickerField(
                    label: "Exterior Color",
                    initialColor: _exteriorColor,
                    onColorSelected: (color) {
                      setState(() {
                        _exteriorColor = color;
                      });
                    },
                  ),

                  SizedBox(height: height * .01),

                  // Interior Color Picker
                  ColorPickerField(
                    label: "Interior Color",
                    initialColor: _interiorColor,
                    onColorSelected: (color) {
                      setState(() {
                        _interiorColor = color;
                      });
                    },
                  ),
                  SizedBox(height: height * .01),

                  // Mileage Text Field
                  CustomTextField(
                    fromCreateAd: true,
                    controller: _plateNumberController,
                    label: "Plate Number",
                    keyboardType: TextInputType.number,   cursorColor: AppColors.brandBlue,
                    cursorHeight: 25.h,
                  ),
                  SizedBox(height: height * .01),

                  // Mileage Text Field
                  CustomTextField(
                    fromCreateAd: true,
                    controller: _chassisNumberController,
                    label: "Chassis Number",
                    keyboardType: TextInputType.number,   cursorColor: AppColors.brandBlue,
                    cursorHeight: 25.h,
                  ),
                  SizedBox(height: height * .01),
                  CustomDropDownTyping(
                    label: "Under Warranty",
                    controller: _warranty_controller,
                    options: ["No", "Yes"],
                    enableSearch: false,
                    onChanged: (value) {
                      setState(() {
                        selectedunderWarranty = value;
                      });
                    },
                  ),
                  SizedBox(height: height * .01),
                  Text(
                    'Car Description',
                    style: TextStyle(
                      fontSize: 15.w,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * .01),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                        hintText: 'Enter car description...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  // Description Text Area
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        // 👈 يلغي الـ extra tap area
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms and Conditions',
                          style: TextStyle(fontSize: 15.w),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        // 👈 يلغي الـ extra tap area
                        value: _infoConfirmed,
                        onChanged: (value) {
                          setState(() {
                            _infoConfirmed = value ?? false;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(height: 15.h),
                            Text(
                              'I confirm the accuracy of the information provided',
                              style: TextStyle(fontSize: 15.w),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * .01),

                  // Post Ad Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .03),
                    child: SizedBox(
                      width: double.infinity,
                      height: height * .05,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle form submission
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff6c42d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'You agree to Qars Spin Terms & Conditions',
                      style: TextStyle(fontSize: 12.w),
                    ),
                  ),
                  SizedBox(height: height * .04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
