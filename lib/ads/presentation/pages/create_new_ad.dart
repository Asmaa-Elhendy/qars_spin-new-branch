import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/drop_Down_field.dart';
import '../widgets/image_picker_field.dart';
import '../widgets/text_field.dart';
import '../widgets/color_picker_field.dart';

class SellCarScreen extends StatefulWidget {
  @override
  _SellCarScreenState createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  List<String> _images = [];
  String? _coverImage;
  String? selectedMake;
  String? selectedModel;
  String? selectedType;
  String? selectedYear;
  String? selectedTrim;
  String? selectedClass;
  Color _exteriorColor = Color(0xffd54245);
  Color _interiorColor = Color(0xff4242d4);
  bool _termsAccepted = false;
  bool _infoConfirmed = false;
  
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _exteriorColorController = TextEditingController();
  final TextEditingController _interiorColorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _handleImageSelected(String imagePath) {
    setState(() {
      _images.add(imagePath);
      // If this is the first image or the only image, set it as cover
      if (_images.length == 1) {
        _coverImage = imagePath;
      }
    });
  }

  void _handleCoverChanged(String? imagePath) {
    if (imagePath != null) {
      setState(() {
        _coverImage = imagePath;
      });
    }
  }

  void _handleImageRemoved(int index) {
    if (index >= 0 && index < _images.length) {
      setState(() {
        String removedImage = _images[index];
        _images.removeAt(index);
        
        // If we removed the cover image or there's only one image left
        if (_coverImage == removedImage || _images.length == 1) {
          _coverImage = _images.isNotEmpty ? _images[0] : null;
        }
      });
    }
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _exteriorColorController.dispose();
    _interiorColorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell Your Car", style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*.05)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Padding(
             padding:  EdgeInsets.symmetric(horizontal: width*.03),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               Padding(
                 padding:  EdgeInsets.symmetric(vertical: height*.01),
                 child: Center(child: Text("Upload Your up to 15 Photos and 1 Video ", style: TextStyle(fontSize: width*.03,fontWeight: FontWeight.bold))),
               ),

               // Cover Image Preview
               if (_coverImage != null && _coverImage!.isNotEmpty)
                 SizedBox(
                   width: double.infinity,
                   height: height * .35,
                   child: Image.file(
                     File(_coverImage!),
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                   ),
                 ),
               SizedBox(height:height*.02),
               ImagePickerField(
                 imagePaths: _images,
                 coverImage: _coverImage,
                 maxImages: 15,
                 onImageSelected: _handleImageSelected,
                 onCoverChanged: _handleCoverChanged,
                 onImageRemoved: _handleImageRemoved,
               ),

               SizedBox(height: height*.02),

               Text("(*) Mandatory Choice", style: TextStyle(fontSize: width*.04, )),
               SizedBox(height: height*.01),
               // Make Dropdown
               DropdownField(
                 label: "Choose Make(*)",
                 items: ["Toyota", "Honda", "BMW", "Mercedes"],
                 onChanged: (value) {
                   setState(() {
                     selectedMake = value;
                   });
                 },
               ),

               SizedBox(height: height*.01),
               // Make Dropdown
               DropdownField(
                 label: "Choose Class(*)",
                 items: ["Toyota", "Honda", "BMW", "Mercedes"],
                 onChanged: (value) {
                   setState(() {
                     selectedClass = value;
                   });
                 },
               ),  SizedBox(height: height*.01),

               // Model Dropdown
               DropdownField(
                 label: "Choose Model(*)",
                 items: [ "Camry", "Corolla", "RAV4", "Highlander"],
                 onChanged: (value) {
                   setState(() {
                     selectedModel = value;
                   });
                 },
               ),

               SizedBox(height: height*.01),
               DropdownField(
                 label: "Choose Type(*)",
                 items: ["4*4", "Bus", "Coupe"],
                 onChanged: (value) {
                   setState(() {
                     selectedType = value;
                   });
                 },
               ),

               SizedBox(height: height*.01),
               // Year Dropdown
               DropdownField(
                 label: "Manufacture Year(*)",
                 items: List.generate(21, (index) => (DateTime.now().year - index).toString())
                     .toList()..insert(0, "Select Year"),
                 onChanged: (value) {
                   setState(() {
                     selectedYear = value;
                   });
                 },
               ),

               SizedBox(height: height*.01),

               // Mileage Text Field
               CustomTextField(
                 controller: _mileageController,
                 label: "Asking Price(*)",
                 keyboardType: TextInputType.number,
               ),
               SizedBox(height: height*.01),

               // Mileage Text Field
               CustomTextField(
                 controller: _mileageController,
                 label: "Minimum biding price yoou want to see",
                 keyboardType: TextInputType.number,
               ),
               SizedBox(height: height*.01),

               // Mileage Text Field
               CustomTextField(
                 controller: _mileageController,
                 label: "Mileage(*)",
                 keyboardType: TextInputType.number,
               ),

               SizedBox(height: height*.01),

               // Exterior Color Picker
               ColorPickerField(
                 label: "Exterior Color",
                 initialColor: _exteriorColor,
                 onColorSelected: (color) {
                   setState(() {
                     _exteriorColor = color;
                   });
                 },
               ),

               SizedBox(height: height*.01),

               // Interior Color Picker
               ColorPickerField(
                 label: "Interior Color",
                 initialColor: _interiorColor,
                 onColorSelected: (color) {
                   setState(() {
                     _interiorColor = color;
                   });
                 },
               ),

               SizedBox(height: height*.01),
               Text(
                 'Car Description',
                 style: TextStyle(
                   fontSize: width*.04,
                   fontWeight: FontWeight.w500,
                   color: Colors.black87,
                 ),
               ),
               SizedBox(height: height*.01),
               Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey.shade600),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: TextField(
                   controller: _descriptionController,
                   maxLines: 5,
                   decoration: InputDecoration(
                     contentPadding: EdgeInsets.all(12),
                     border: InputBorder.none,
                     hintText: 'Enter car description...',
                     hintStyle: TextStyle(color: Colors.grey.shade400),
                   ),
                 ),
               ),
               // Description Text Area
             ],),
           ),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms and Conditions',
                    style: TextStyle(fontSize: width*.04),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _infoConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _infoConfirmed = value ?? false;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Expanded(
                  child: Text(
                    'I confirm the accuracy of the information provided',
                    style: TextStyle(fontSize: width*.04),
                  ),
                ),
              ],
            ),

            SizedBox(height: height*.01),

            // Post Ad Button
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*.03),
              child: SizedBox(
                width: double.infinity,
                height: height*.07,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff6c42d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: width*.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height*.04,)
          ],
        ),
      ),
    );
  }
}
