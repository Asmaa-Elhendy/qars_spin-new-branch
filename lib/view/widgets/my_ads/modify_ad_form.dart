import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:qarsspin/controller/const/base_url.dart';

import '../../../controller/const/colors.dart';
import '../ads/color_picker_field.dart';

class ModifyCarAdForm extends StatefulWidget {
  const ModifyCarAdForm({super.key});

  @override
  State<ModifyCarAdForm> createState() => _ModifyCarAdFormState();
}

class _ModifyCarAdFormState extends State<ModifyCarAdForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final makeController = TextEditingController();
  final classController = TextEditingController();
  final modelController = TextEditingController();
  final typeController = TextEditingController();
  final yearController = TextEditingController();
  final askingPriceController = TextEditingController();
  final minPriceController = TextEditingController();
  final mileageController = TextEditingController();
  final plateNumberController = TextEditingController();

  Color _exteriorColor = Color(0xffd54245);
  Color _interiorColor = Color(0xff4242d4);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 470.h,
        child: ListView(

          padding: const EdgeInsets.all(16),
          children: [
            buildSearchableDropdown(
              label: "Choose Make (*)",
              items: ["TOYOTA", "HONDA", "BMW", "FORD", "KIA"],
              myController: makeController
            ),
            buildSearchableDropdown(
              label: "Choose Class (*)",
              items: ["Avalon", "Corolla", "Civic", "Accord"],
              myController: classController
            ),
            buildSearchableDropdown(
              label: "Choose Model (*)",
              items: ["XL", "XLE", "Sport", "Luxury"],
              myController: modelController
            ),
            buildSearchableDropdown(
              label: "Choose Type",
              items: ["SUV", "Sedan", "Truck", "Coupe"],
              myController: typeController
            ),
            buildSearchableDropdown(
              label: "Manufacture Year (*)",
              items: List.generate(30, (index) => (2024 - index).toString()),
              myController: yearController
            ),
            buildTextField("Asking Price (*)", askingPriceController,
                keyboardType: TextInputType.number),
            buildTextField("Minimum Price", minPriceController,
                keyboardType: TextInputType.number),
            buildTextField("Mileage (*)", mileageController,
                keyboardType: TextInputType.number),
            10.verticalSpace,
            ColorPickerField(
              modify: true,
              label: "Exterior Color",
              initialColor: _exteriorColor,
              onColorSelected: (color) {
                setState(() {
                  _exteriorColor = color;
                });
              },
            ),

            10.verticalSpace,

            // Interior Color Picker
            ColorPickerField(
              modify: true,
              label: "Interior Color",
              initialColor: _interiorColor,
              onColorSelected: (color) {
                setState(() {
                  _interiorColor = color;
                });
              },
            ),
            10.verticalSpace,

            buildTextField("Plate Number", plateNumberController),
          ],
        ),
      ),
    );
  }

  /// 🔹 Function to build searchable dropdown
  Widget buildSearchableDropdown({
    required String label,
    required List<String> items,
    required TextEditingController myController,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          10.verticalSpace,

          /// TypeAhead Field
          SizedBox(
            height: 40.h,
            child: TypeAheadField<String>(
              // suggestions
              suggestionsCallback: (pattern) async {
                return items
                    .where((car) =>
                    car.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },

              // TextField UI
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: myController, // use your external controller
                  focusNode: focusNode,
                  onChanged: (val) {
                    controller.text = val; // sync with internal one
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 6.w),
                  ),
                );
              },

              // how suggestions look
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 10.h),
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.mutedGray,
                    ),
                  ),
                );
              },

              // when user selects one
              onSelected: (suggestion) {
                myController.text = suggestion;
              },

              // popup decoration
              decorationBuilder: (context, child) {
                return Container(
                  height: 230.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//       ),
    //     ],
    //   ),
    // );
  }

  /// 🔹 Function to build normal TextField
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          10.verticalSpace,
          SizedBox(
            height: 40.h,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                //labelText: label,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.mutedGray, width: 1), // عادي
                ),
                border: const OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mutedGray),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              cursorColor: AppColors.lightGray,
              cursorWidth: 1,
            ),
          ),
        ],
      ),
    );
  }


