import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? suffixText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool fromCreateAd;
  final double? height;
  final Color? cursorColor;
  final double? cursorHeight;
  final String? hintText;

  const CustomTextField({
    Key? key,
    required this.label,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.prefixText,
    this.suffixText,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.fromCreateAd=false,
    this.height,
    this.cursorColor,
    this.cursorHeight,
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
            fontSize: 15.w,
            fontWeight: FontWeight.w500,

          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: AppColors.white,
          height: this.height ?? (fromCreateAd?height*.045:height*.05),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            obscureText: obscureText,
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            cursorColor: cursorColor,
            cursorHeight: cursorHeight,

            style: TextStyle(fontSize: 15.w,
            color: AppColors.black
            ),

            decoration: InputDecoration(
              fillColor: AppColors.black,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 1,


              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fromCreateAd?5:8),
                borderSide: BorderSide(color: Colors.black,width: 0.3),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fromCreateAd?5:8),
                borderSide: BorderSide(color: Colors.black,width: 0.3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fromCreateAd?5:8),
                borderSide: BorderSide(color: Colors.black, width:fromCreateAd?0.3: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fromCreateAd?5:8),
                borderSide: const BorderSide(color: Colors.red,width: 0.3),
              ),
              prefixText: prefixText,
              suffixText: suffixText,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}