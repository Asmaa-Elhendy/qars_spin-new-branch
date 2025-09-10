import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../controller/const/colors.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? hintText;

  const DropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize:15.w
            ,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height*.045,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
              isExpanded: true,
              value: value,
              hint: hintText != null ? Text(hintText!) : null,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
class CustomDropDownTyping extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;

  const CustomDropDownTyping({
    Key? key,
    required this.label,
    required this.controller,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize:15.w,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height * .045, //update asmaa
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 0.3),//update
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TypeAheadField<String>(
            suggestionsCallback: (pattern) async {
              return options
                  .where((car) =>
                  car.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },

            // TextField UI
            builder: (context, textEditingController, focusNode) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: (val) {
                        controller.text = val;
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      },
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              );
            },

            // suggestion list
            itemBuilder: (context, suggestion) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  suggestion,
                  style: TextStyle(
                    fontSize: 14.sp,
                   // fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              );
            },

            // on select
            onSelected: (suggestion) {
              controller.text = suggestion;
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
    );
  }
}

