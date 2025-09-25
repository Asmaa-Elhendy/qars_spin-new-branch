import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/model/global_model.dart';

import '../../../controller/search_controller.dart';
import '../my_ads/yellow_buttons.dart';

class CustomFormSheet extends StatefulWidget {
  String myCase;
  CustomFormSheet({required this.myCase,super.key});

  @override
  State<CustomFormSheet> createState() => _CustomFormSheetState();
}

class _CustomFormSheetState extends State<CustomFormSheet> {
  final makeController = TextEditingController();
  final classController = TextEditingController();
  final modelController = TextEditingController();
  final typeController = TextEditingController();
  final fromYearController = TextEditingController();
  final toYearController = TextEditingController();
  final fromPriceController = TextEditingController();
  final toPriceController = TextEditingController();
  String selctedMakeId = "";
  String selectedClassId = "";
  String selectedModelId = "";
  String selectedTypeId = "";

  List<GlobalModel> years = List.generate(
    30,
        (index) {
      final year = (2024 - index).toString();
      return GlobalModel(id:int.parse(year), name: year);
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<MySearchController>().fetchCarMakes();

  }

  @override
  void dispose() {
    makeController.dispose();
    classController.dispose();
    modelController.dispose();
    typeController.dispose();
    fromYearController.dispose();
    toYearController.dispose();
    fromPriceController.dispose();
    toPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MySearchController>(
        builder: (controller) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 900.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: AppColors.mutedGray, width: 1.h),

                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8).r, // 👈 rounded top only
                ),
              ),

              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 6.h),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 43.w,
                          height:5.h,
                          decoration: BoxDecoration(
                            color: AppColors.inputBorder,

                            borderRadius: BorderRadius.circular(8),
                          ),

                        ),
                      ),
                      18.verticalSpace,
                      Center(child: title("Search"),),
                      8.verticalSpace,
                      Divider(color: AppColors.darkGray,thickness: .5.h,),
                      16.verticalSpace,
                      form(),




                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
  Widget title(String title){
    return Text(title,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
  Widget form(){
    return GetBuilder<MySearchController>(
        builder: (controller) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                buildSearchableDropdown(
                    label: "Choose Make",
                    items: controller.makes,
                    myController: makeController
                ),
                buildSearchableDropdown(
                    label: "Choose Class",
                    items: controller.classes,
                    myController: classController
                ),
                buildSearchableDropdown(
                    label: "Choose Model",
                    items: controller.model,
                    myController: modelController
                ),
                buildSearchableDropdown(
                    label: "Choose Type",
                    items: controller.types,
                    myController: typeController
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 30.w,
                  children: [
                    Expanded(
                      child: buildSearchableDropdown(
                          label: "From Year",
                          items: years,
                          myController: fromYearController
                      ),
                    ),
                    Expanded(
                      child: buildSearchableDropdown(
                          label: "To Year",
                          items: years,
                          myController: toYearController
                      ),
                    ),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 30.w,
                  children: [
                    Expanded(
                      child: buildTextField("From Price", fromPriceController,
                          keyboardType: TextInputType.number),
                    ),
                    Expanded(
                      child: buildTextField("To Price", toPriceController,
                          keyboardType: TextInputType.number),
                    ),


                  ],
                ),
                35.verticalSpace,
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10.w,
                  children: [
                    cancelButton((){
                      Navigator.pop(context,"");
                    },"Cancel"),

                    searchButton((){
                      Get.find<BrandController>().searchCar(
                          make_id: int.parse(selctedMakeId),
                          makeName: makeController.text,
                          classId: selectedClassId,
                          makeId: selctedMakeId,
                          modelId: selectedModelId,
                          yearMin: fromYearController.text,
                          yearMax: toYearController.text,
                          priceMin: fromPriceController.text,
                          priceMax: toPriceController.text, catId: selectedTypeId);
                      Navigator.pop(context,"no data");
                    })

                  ],
                )



              ],
            ),
          );
        }
    );
  }
  Widget buildSearchableDropdown({
    required String label,
    required List<GlobalModel> items,
    required TextEditingController myController,
  }) {
    return GetBuilder<MySearchController>(

        builder: (controller) {
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
                  height: 45.h,
                  child: TypeAheadField<GlobalModel>(

                    // suggestions
                    suggestionsCallback: (pattern) async {
                      return items
                          .where((car) =>
                          car.name.toLowerCase().contains(pattern.toLowerCase()))
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: AppColors.mutedGray,
                              width: .8.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: AppColors.mutedGray,
                              width: .8.w,
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
                          suggestion.name,
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
                      myController.text = suggestion.name;
                      switch(label){
                        case "Choose Make":
                          controller.fetchClasses(suggestion.id);
                          selctedMakeId = suggestion.id.toString();
                          break;
                        case "Choose Class":
                          controller.fetchModels(suggestion.id);
                          selectedClassId = suggestion.id.toString();
                        case "choose type":
                          selectedTypeId = suggestion.id.toString();

                      }
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
    );
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
                  BorderSide(color: AppColors.mutedGray, width: .8.w), // عادي
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
  cancelButton(ontap,title){
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 185.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.extraLightGray,
          borderRadius: BorderRadius.circular(4), // optional rounded corners

        ),
        child: Center(
          child: Text(title,

            style: TextStyle(
              color: AppColors.black,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),

    );
  }

  Widget searchButton(onTap){
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 185.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4), // optional rounded corners

        ),
        child: Center(
          child: Text("Search",

            style: TextStyle(
              color: AppColors.black,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),

    );
  }

}
