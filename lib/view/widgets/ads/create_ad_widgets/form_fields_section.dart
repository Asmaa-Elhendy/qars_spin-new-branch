import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/ads/ad_getx_controller_create_ad.dart';
import '../../../../controller/ads/data_layer.dart';
import '../../../../controller/const/colors.dart';
import '../color_picker_field.dart';
import '../drop_Down_field.dart';
import '../text_field.dart';

class FormFieldsSection extends StatefulWidget {
  final TextEditingController makeController;
  final TextEditingController classController;
  final TextEditingController modelController;
  final TextEditingController typeController;
  final TextEditingController yearController;
  final TextEditingController warrantyController;
  final TextEditingController askingPriceController;
  final TextEditingController minimumPriceController;
  final TextEditingController mileageController;
  final TextEditingController plateNumberController;
  final TextEditingController chassisNumberController;
  final TextEditingController descriptionController;
  final Color exteriorColor;
  final Color interiorColor;
  final Function(Color) onExteriorColorSelected;
  final Function(Color) onInteriorColorSelected;
  final bool termsAccepted;
  final bool infoConfirmed;
  final ValueChanged<bool?>? onTermsChanged;
  final ValueChanged<bool?>? onInfoChanged;
  final Function() onValidateAndSubmit;

  const FormFieldsSection({
    Key? key,
    required this.makeController,
    required this.classController,
    required this.modelController,
    required this.typeController,
    required this.yearController,
    required this.warrantyController,
    required this.askingPriceController,
    required this.minimumPriceController,
    required this.mileageController,
    required this.plateNumberController,
    required this.chassisNumberController,
    required this.descriptionController,
    required this.exteriorColor,
    required this.interiorColor,
    required this.onExteriorColorSelected,
    required this.onInteriorColorSelected,
    required this.termsAccepted,
    required this.infoConfirmed,
    required this.onTermsChanged,
    required this.onInfoChanged,
    required this.onValidateAndSubmit,
  }) : super(key: key);

  @override
  _FormFieldsSectionState createState() => _FormFieldsSectionState();
}

class _FormFieldsSectionState extends State<FormFieldsSection> {
  late AdCleanController brandController;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    try {
      brandController = Get.find<AdCleanController>();
      print('AdCleanController found successfully');
      print('Categories count: ${brandController.carCategories.length}');
    } catch (e) {
      print('Error finding AdCleanController: $e');
      // Fallback: create a new instance
      brandController = Get.put(AdCleanController(AdRepository()));
      print('Created new AdCleanController instance');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * .02),

        Text(
          "(*) Mandatory Choice",
          style: TextStyle(fontSize: width * .04),
        ),
        SizedBox(height: height * .01),

        // Make Dropdown
        Obx(() => CustomDropDownTyping(
          label: "Choose Make(*)",
          controller: widget.makeController,
          options: brandController.carBrands
              .map((b) => b.name)
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
          onChanged: (value) {
            final selected = brandController.carBrands
                .firstWhereOrNull((b) => b.name == value);

            if (selected != null) {
              brandController.selectedMake.value = selected;
              widget.makeController.text = selected.name;
              log("heee   ${widget.makeController.text}");
              brandController.fetchCarClasses(selected.id.toString());
              widget.classController.clear();
              brandController.selectedClass.value = null;
              setState(() {});
            } else if (value.isEmpty) {
              widget.classController.clear();
              brandController.selectedClass.value = null;
              brandController.carClasses.clear();
              widget.modelController.clear();
              brandController.selectedModel.value = null;
              brandController.carModels.clear();
              setState(() {});
            }
          },
        )),

        SizedBox(height: height * .01),
        
        // Class Dropdown
        Obx(() {
          return CustomDropDownTyping(
            label: "Choose Class(*)",
            controller: widget.classController,
            options: brandController.carClasses.map((c) => c.name).toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
            onChanged: (value) {
              final selected = brandController.carClasses
                  .firstWhereOrNull((c) => c.name == value);
              if (selected != null) {
                brandController.selectedClass.value = selected;
                brandController.fetchCarModels(selected.id.toString());
                widget.modelController.clear();
                brandController.selectedModel.value = null;
                setState(() {});
              } else if (value.isEmpty) {
                widget.modelController.clear();
                brandController.selectedModel.value = null;
                brandController.carModels.clear();
                setState(() {});
              }
            },
          );
        }),

        SizedBox(height: height * .01),
        
        // Model Dropdown
        Obx(() {
          return CustomDropDownTyping(
            label: "Choose Model(*)",
            controller: widget.modelController,
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

        SizedBox(height: height * .01),
        
        // Car Type Dropdown - Using dynamic categories from API
        Obx(() {
          print('Obx rebuilding for car categories. Count: ${brandController.carCategories.length}');
          print('Loading state: ${brandController.isLoadingCategories.value}');
          final categoryOptions = brandController.carCategories
              .map((c) => c.name)
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          print('Category options: $categoryOptions');
          
          return CustomDropDownTyping(
            label: "Choose Type(*)",
            controller: widget.typeController,
            options: categoryOptions,
            enableSearch: false,
            onChanged: (value) {
              print('Type selected: $value');
              final selected = brandController.carCategories
                  .firstWhereOrNull((c) => c.name == value);
              if (selected != null) {
                brandController.selectedCategory.value = selected;
                widget.typeController.text = selected.name;
                setState(() {
                  selectedType = selected.name;
                });
                print('Selected category: ${selected.id} - ${selected.name}');
              } else if (value.isEmpty) {
                brandController.selectedCategory.value = null;
                setState(() {
                  selectedType = null;
                });
                print('Category cleared');
              }
            },
          );
        }),

        SizedBox(height: height * .01),
        
        // Year Dropdown
        CustomDropDownTyping(
          label: "Manufacture Year(*)",
          controller: widget.yearController,
          options: List.generate(
            51,
                (index) => (DateTime.now().year + 1 - index).toString(),
          ).toList(),
          enableSearch: false,
          onChanged: (value) {
            setState(() {
              // Handle year selection if needed
            });
          },
        ),

        SizedBox(height: height * .01),

        // Asking Price
        CustomTextField(
          fromCreateAd: true,
          controller: widget.askingPriceController,
          label: "Asking Price(*)",
          keyboardType: TextInputType.number,
          cursorColor: AppColors.brandBlue,
          cursorHeight: 25.h,
        ),
        SizedBox(height: height * .01),

        // Minimum Price
        CustomTextField(
          fromCreateAd: true,
          controller: widget.minimumPriceController,
          label: "Minimum biding price yoou want to see",
          keyboardType: TextInputType.number,
          cursorColor: AppColors.brandBlue,
          cursorHeight: 25.h,
        ),
        SizedBox(height: height * .01),

        // Mileage
        CustomTextField(
          fromCreateAd: true,
          controller: widget.mileageController,
          label: "Mileage(*)",
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: height * .01),

        // Exterior Color Picker
        ColorPickerField(
          label: "Exterior Color",
          initialColor: widget.exteriorColor,
          onColorSelected: widget.onExteriorColorSelected,
        ),

        SizedBox(height: height * .01),

        // Interior Color Picker
        ColorPickerField(
          label: "Interior Color",
          initialColor: widget.interiorColor,
          onColorSelected: widget.onInteriorColorSelected,
        ),
        SizedBox(height: height * .01),

        // Plate Number
        CustomTextField(
          fromCreateAd: true,
          controller: widget.plateNumberController,
          label: "Plate Number",
          keyboardType: TextInputType.number,
          cursorColor: AppColors.brandBlue,
          cursorHeight: 25.h,
        ),
        SizedBox(height: height * .01),

        // Chassis Number
        CustomTextField(
          fromCreateAd: true,
          controller: widget.chassisNumberController,
          label: "Chassis Number",
          keyboardType: TextInputType.number,
          cursorColor: AppColors.brandBlue,
          cursorHeight: 25.h,
        ),
        SizedBox(height: height * .01),
        
        CustomDropDownTyping(
          label: "Under Warranty",
          controller: widget.warrantyController,
          options: ["No", "Yes"],
          enableSearch: false,
          onChanged: (value) {
            setState(() {
              // Handle warranty selection if needed
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
            controller: widget.descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: 'Enter car description...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),

        // Terms and Conditions Checkbox
        Row(
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: widget.termsAccepted,
              onChanged: widget.onTermsChanged,
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
        
        // Info Confirmation Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: widget.infoConfirmed,
              onChanged: widget.onInfoChanged,
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

        // Submit Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .03),
          child: SizedBox(
            width: double.infinity,
            height: height * .05,
            child: ElevatedButton(
              onPressed: widget.onValidateAndSubmit,
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
    );
  }
}
