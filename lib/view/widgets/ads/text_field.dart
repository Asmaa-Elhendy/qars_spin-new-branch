import 'package:flutter/material.dart';

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
            fontSize: width*.04,
            fontWeight: FontWeight.w500,

          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height*.05,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            obscureText: obscureText,
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              prefixText: prefixText,
              suffixText: suffixText,

            ),
          ),
        ),
      ],
    );
  }
}
