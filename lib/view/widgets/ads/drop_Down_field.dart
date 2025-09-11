import 'dart:developer';

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
class CustomDropDownTyping extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final bool enableSearch;

  const CustomDropDownTyping({
    Key? key,
    required this.label,
    required this.controller,
    required this.options,
    this.onChanged,
    this.enableSearch = true,
  }) : super(key: key);

  @override
  State<CustomDropDownTyping> createState() => _CustomDropDownTypingState();
}

class _CustomDropDownTypingState extends State<CustomDropDownTyping> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height * .045,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TypeAheadField<String>(
            key: ValueKey('typeahead_${widget.options.length}_${widget.controller.text}'),
            suggestionsCallback: (pattern) async {
              if (!widget.enableSearch) {
                return widget.options;
              }
              if (pattern.isEmpty) {
                return widget.options;
              }
              return widget.options
                  .where((car) =>
                  car.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            hideOnSelect: true,
            hideOnEmpty: true,
            hideOnError: true,
            builder: (context, controller, focusNode) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      readOnly: !widget.enableSearch,
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
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              );
            },
            itemBuilder: (context, suggestion) {
              return Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  suggestion,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              );
            },
            onSelected: (suggestion) {
              // Ensure the controller text is updated immediately
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.controller.text = suggestion;
                // Call the onChanged callback
                if (widget.onChanged != null) {
                  widget.onChanged!(suggestion);
                }
                // Force immediate UI refresh
                if (mounted) {
                  setState(() {});
                }
              });
            },
            errorBuilder: (context, error) => const SizedBox(),
            loadingBuilder: (context) => const SizedBox(),
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No results found', style: TextStyle(color: Colors.grey)),
            ),
            controller: widget.controller,
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
  
  @override
  void didUpdateWidget(CustomDropDownTyping oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the options changed, we need to rebuild
    if (oldWidget.options != widget.options) {
      setState(() {});
    }
  }
}
