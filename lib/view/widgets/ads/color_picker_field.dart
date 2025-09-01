import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerField extends StatefulWidget {
  final String label;
  final ValueChanged<Color> onColorSelected;
  final Color? initialColor;
  final bool showLabel;

  const ColorPickerField({
    Key? key,
    required this.label,
    required this.onColorSelected,
    this.initialColor,
    this.showLabel = true,
  }) : super(key: key);

  @override
  _ColorPickerFieldState createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  late Color _selectedColor;
  late Color _pickerColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor ?? const Color(0xff443a49);
    _pickerColor = _selectedColor;
  }

  void _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  String _getColorHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: _showColorPickerDialog,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height*.05,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: _pickerColor,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(),
          ),
        ),
      ],
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a ${widget.label.toLowerCase()}!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: _changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
