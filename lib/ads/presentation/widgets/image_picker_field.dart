import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final List<String> imagePaths;
  final String? coverImage;
  final int maxImages;
  final Function(String) onImageSelected;
  final Function(String)? onCoverChanged;
  final Function(int)? onImageRemoved;

  const ImagePickerField({
    Key? key,
    required this.imagePaths,
    this.coverImage,
    this.maxImages = 4,
    required this.onImageSelected,
    this.onCoverChanged,
    this.onImageRemoved,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.imagePaths);
  }

  Future<void> _pickImage() async {
    if (_images.length >= widget.maxImages) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(image.path);
        setState(() {
          _images.add(image.path);
          if (widget.coverImage == null && _images.length == 1) {
            widget.onCoverChanged?.call(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _images.length) return;

    final removedImage = _images[index];
    setState(() {
      _images.removeAt(index);
      widget.onImageRemoved?.call(index);

      // If the removed image was the cover, update the cover
      if (widget.coverImage == removedImage) {
        widget.onCoverChanged?.call(_images.isNotEmpty ? _images[0] : '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._images.asMap().entries.map((entry) {
          final index = entry.key;
          final imgPath = entry.value;
          bool isCover = imgPath == widget.coverImage;

          return Stack(
            children: [
              Container(
                width: width * .2,
                height: width * .2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  image: DecorationImage(
                    image: FileImage(File(imgPath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (widget.onCoverChanged != null && isCover)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => widget.onCoverChanged?.call(imgPath),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Cover',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * .03,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Make the whole image tappable to set as cover
              if (widget.onCoverChanged != null && !isCover)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onCoverChanged?.call(imgPath),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
        if (_images.length < widget.maxImages)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: width * .2,
              height: width * .2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                //  color: Colors.grey[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey[600],
                      size: width * .1,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
