import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';//kh
import '../my_ads/color_picker_dialog.dart';

class ColorPickerField extends StatefulWidget {
  final String label;
  final ValueChanged<Color> onColorSelected;
  final Color? initialColor;
  final bool showLabel;
  bool modify;
  final bool isExterior; // Add this to filter colors

  ColorPickerField({
    Key? key,
    required this.label,
    this.modify = false,
    required this.onColorSelected,
    this.initialColor,
    this.showLabel = true,
    this.isExterior = true, // Default to exterior colors
  }) : super(key: key);

  @override
  _ColorPickerFieldState createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  late Color _selectedColor;
  late ColorData _selectedColorData;
  late List<ColorData> _filteredColors;

  @override
  void initState() {
    super.initState();
    // Set default color based on whether it's exterior or interior
    if (widget.initialColor != null) {
      _selectedColor = widget.initialColor!;
    } else {
      _selectedColor = widget.isExterior ? const Color(0xff800000) : const Color(0xff4682B4); // Steel blue for interior
    }
    _initializeColors();
  }

  void _initializeColors() {
    // All available colors from the database
    final List<ColorData> allColors = [
      // Exterior colors (isExterior: true)
      ColorData(colorId: 1, hexCode: '#FFFFFF', namePL: 'White', nameSL: 'أبيض', isExterior: true, displayOrder: 1),
      ColorData(colorId: 2, hexCode: '#000000', namePL: 'Black', nameSL: 'أسود', isExterior: true, displayOrder: 2),
      ColorData(colorId: 3, hexCode: '#C0C0C0', namePL: 'Silver', nameSL: 'فضي', isExterior: true, displayOrder: 3),
      ColorData(colorId: 4, hexCode: '#808080', namePL: 'Gray', nameSL: 'رمادي', isExterior: true, displayOrder: 4),
      ColorData(colorId: 5, hexCode: '#FF0000', namePL: 'Red', nameSL: 'أحمر', isExterior: true, displayOrder: 5),
      ColorData(colorId: 6, hexCode: '#800000', namePL: 'Maroon', nameSL: 'عنابي', isExterior: true, displayOrder: 6),
      ColorData(colorId: 7, hexCode: '#FFFF00', namePL: 'Yellow', nameSL: 'أصفر', isExterior: true, displayOrder: 7),
      ColorData(colorId: 8, hexCode: '#808000', namePL: 'Olive', nameSL: 'زيتوني', isExterior: true, displayOrder: 8),
      ColorData(colorId: 9, hexCode: '#00FF00', namePL: 'Lime', nameSL: 'ليموني', isExterior: true, displayOrder: 9),
      ColorData(colorId: 10, hexCode: '#008000', namePL: 'Green', nameSL: 'أخضر', isExterior: true, displayOrder: 10),
      ColorData(colorId: 11, hexCode: '#00FFFF', namePL: 'Cyan', nameSL: 'سماوي', isExterior: true, displayOrder: 11),
      ColorData(colorId: 12, hexCode: '#008080', namePL: 'Teal', nameSL: 'تركوازي', isExterior: true, displayOrder: 12),
      ColorData(colorId: 13, hexCode: '#0000FF', namePL: 'Blue', nameSL: 'أزرق', isExterior: true, displayOrder: 13),
      ColorData(colorId: 14, hexCode: '#000080', namePL: 'Navy', nameSL: 'كحلي', isExterior: true, displayOrder: 14),
      ColorData(colorId: 15, hexCode: '#FF00FF', namePL: 'Magenta', nameSL: 'وردي فاتح', isExterior: true, displayOrder: 15),
      ColorData(colorId: 16, hexCode: '#800080', namePL: 'Purple', nameSL: 'أرجواني', isExterior: true, displayOrder: 16),
      ColorData(colorId: 17, hexCode: '#D2691E', namePL: 'Brown', nameSL: 'بني', isExterior: true, displayOrder: 17),
      ColorData(colorId: 18, hexCode: '#F5DEB3', namePL: 'Beige', nameSL: 'بيج', isExterior: true, displayOrder: 18),
      ColorData(colorId: 19, hexCode: '#FF4500', namePL: 'Orange', nameSL: 'برتقالي', isExterior: true, displayOrder: 19),
      ColorData(colorId: 20, hexCode: '#A52A2A', namePL: 'Dark Brown', nameSL: 'بني غامق', isExterior: true, displayOrder: 20),
      ColorData(colorId: 21, hexCode: '#E6E6FA', namePL: 'Lavender', nameSL: 'لافندر', isExterior: true, displayOrder: 21),
      ColorData(colorId: 22, hexCode: '#FA8072', namePL: 'Salmon', nameSL: 'مرجاني', isExterior: true, displayOrder: 22),
      ColorData(colorId: 23, hexCode: '#2F4F4F', namePL: 'Dark Slate Gray', nameSL: 'رمادي أردوازي غامق', isExterior: true, displayOrder: 23),
      ColorData(colorId: 24, hexCode: '#4682B4', namePL: 'Steel Blue', nameSL: 'أزرق فولاذي', isExterior: true, displayOrder: 24),
      
      // Interior colors (isExterior: false)
      ColorData(colorId: 25, hexCode: '#FFFFFF', namePL: 'White', nameSL: 'أبيض', isExterior: false, displayOrder: 1),
      ColorData(colorId: 26, hexCode: '#000000', namePL: 'Black', nameSL: 'أسود', isExterior: false, displayOrder: 2),
      ColorData(colorId: 27, hexCode: '#C0C0C0', namePL: 'Silver', nameSL: 'فضي', isExterior: false, displayOrder: 3),
      ColorData(colorId: 28, hexCode: '#808080', namePL: 'Gray', nameSL: 'رمادي', isExterior: false, displayOrder: 4),
      ColorData(colorId: 29, hexCode: '#D2691E', namePL: 'Brown', nameSL: 'بني', isExterior: false, displayOrder: 5),
      ColorData(colorId: 30, hexCode: '#F5DEB3', namePL: 'Beige', nameSL: 'بيج', isExterior: false, displayOrder: 6),
      ColorData(colorId: 31, hexCode: '#8B4513', namePL: 'Saddle Brown', nameSL: 'بني سرج', isExterior: false, displayOrder: 7),
      ColorData(colorId: 32, hexCode: '#A52A2A', namePL: 'Dark Brown', nameSL: 'بني غامق', isExterior: false, displayOrder: 8),
      ColorData(colorId: 33, hexCode: '#FAEBD7', namePL: 'Antique White', nameSL: 'أبيض قديم', isExterior: false, displayOrder: 9),
      ColorData(colorId: 34, hexCode: '#FFF5EE', namePL: 'Seashell', nameSL: 'صدفي', isExterior: false, displayOrder: 10),
      ColorData(colorId: 35, hexCode: '#2F4F4F', namePL: 'Dark Slate Gray', nameSL: 'رمادي أردوازي غامق', isExterior: false, displayOrder: 11),
      ColorData(colorId: 36, hexCode: '#708090', namePL: 'Slate Gray', nameSL: 'رمادي أردوازي', isExterior: false, displayOrder: 12),
      ColorData(colorId: 37, hexCode: '#4682B4', namePL: 'Steel Blue', nameSL: 'أزرق فولاذي', isExterior: false, displayOrder: 13),
      ColorData(colorId: 38, hexCode: '#778899', namePL: 'Light Slate Gray', nameSL: 'رمادي أردوازي فاتح', isExterior: false, displayOrder: 14),
      ColorData(colorId: 39, hexCode: '#B0C4DE', namePL: 'Light Steel Blue', nameSL: 'أزرق فولاذي فاتح', isExterior: false, displayOrder: 15),
    ];

    // Filter colors based on exterior/interior
    _filteredColors = allColors.where((color) => color.isExterior == widget.isExterior).toList();
    
    // Sort by display order
    _filteredColors.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    
    // Find the initial color data that matches the initial color
    _selectedColorData = _filteredColors.firstWhere(
      (colorData) => colorData.color == _selectedColor,
      orElse: () => _filteredColors.first,
    );
    
    // Debug logging to verify default color selection
    print('🎨 [COLOR_PICKER] Default color selected: ${_selectedColorData.nameSL} (${_selectedColorData.hexCode}) for ${widget.isExterior ? "exterior" : "interior"}');
  }

  void _showColorPickerDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final selectedColorData = await showColorPickerDialog(
      context: context,
      colors: _filteredColors,
      initialColor: _selectedColorData,
      title: 'Pick a ${widget.label.toLowerCase()}',
    );

    if (selectedColorData != null) {
      setState(() {
        _selectedColor = selectedColorData.color;
        _selectedColorData = selectedColorData;
      });
      widget.onColorSelected(selectedColorData.color);
      log('Selected color: ${selectedColorData.nameSL} (${selectedColorData.hexCode})');
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: widget.modify
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  )
                : TextStyle(
                    fontSize: 15.w,
                    fontWeight: FontWeight.w500,
                  ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: _showColorPickerDialog,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height * 0.05,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: _selectedColor,
              border: Border.all(color: Colors.black, width: 0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(),
          ),
        ),
      ],
    );
  }
}
