import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/view/widgets/my_ads/yellow_buttons.dart';

class FindMeACar extends StatefulWidget {
  const FindMeACar({super.key});

  @override
  State<FindMeACar> createState() => _FindMeACarState();
}

class _FindMeACarState extends State<FindMeACar> {
  final makeController = TextEditingController();
  final classController = TextEditingController();
  final modelController = TextEditingController();
  final typeController = TextEditingController();
  final fromYearController = TextEditingController();
  final toYearController = TextEditingController();
  final fromPriceController = TextEditingController();
  final toPriceController = TextEditingController();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 88.h, // same as your AppBar height
              padding: EdgeInsets.only(top: 13.h,left: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // shadow color
                    blurRadius: 6, // softens the shadow
                    offset: Offset(0, 2), // moves shadow downward
                  ),
                ],
              ),
              child: Row(


                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // go back
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                      size: 30.w,
                    ),
                  ),
                  130.horizontalSpace,
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Find Me A Car",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
              child:  Text(
                "Get notified when a car of your choice is\n                   added to our showroom.",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Gilroy',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            24.verticalSpace,
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.w),

              child: Container(
                height: .7.h,
                decoration: BoxDecoration(
                  color: AppColors.black,

                ),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  buildSearchableDropdown(
                      label: "Choose Make",
                      items: ["TOYOTA", "HONDA", "BMW", "FORD", "KIA"],
                      myController: makeController
                  ),
                  buildSearchableDropdown(
                      label: "Choose Class",
                      items: ["Avalon", "Corolla", "Civic", "Accord"],
                      myController: classController
                  ),
                  buildSearchableDropdown(
                      label: "Choose Model",
                      items: ["XL", "XLE", "Sport", "Luxury"],
                      myController: modelController
                  ),
                  buildSearchableDropdown(
                      label: "Choose Type",
                      items: ["SUV", "Sedan", "Truck", "Coupe"],
                      myController: typeController
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 30.w,
                    children: [
                      Expanded(
                        child: buildSearchableDropdown(
                            label: "From Year",
                            items: List.generate(30, (index) => (2024 - index).toString()),
                            myController: fromYearController
                        ),
                      ),
                      Expanded(
                        child: buildSearchableDropdown(
                            label: "To Year",
                            items: List.generate(30, (index) => (2024 - index).toString()),
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
                  50.verticalSpace,
                  buildLargeTextField("Any Comments?", commentController,
                      keyboardType: TextInputType.number),
                  20.verticalSpace,
                  yellowButtons(title: "Activate Notification", onTap: (){}, w: double.infinity),
                  40.verticalSpace


                ],
              ),
            )



          ],
        ),
      ),
    );
  }
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
            height: 45.h,
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

  Widget buildLargeTextField(String label, TextEditingController controller,
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
            height: 140.h,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
              ),
              decoration: InputDecoration(
                hintText: "eg.exterior or interior color of the car, options,\nengine...", // 👈 الهنت
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(
                    color: AppColors.inputBorder,
                    width: .6.w,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: AppColors.mutedGray, width: .8.w), // عادي
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(
                    color: AppColors.inputBorder,
                    width: 1,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 6.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
