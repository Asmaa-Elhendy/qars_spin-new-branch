import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../image_picker_field.dart';
import '../video_player_widget.dart';

class ImageUploadSection extends StatefulWidget {
  final List<String> images;
  final String? coverImage;
  final String? videoPath;
  final Function(String) onImageSelected;
  final Function(String) onVideoSelected;
  final Function(String) onCoverChanged;
  final Function(int) onImageRemoved;
  final bool isModifyMode;
  final Function(bool) onCoverPhotoChanged;
  final Function(bool)? onVideoChanged;

  const ImageUploadSection({
    Key? key,
    required this.images,
    required this.coverImage,
    required this.videoPath,
    required this.onImageSelected,
    required this.onVideoSelected,
    required this.onCoverChanged,
    required this.onImageRemoved,
    this.isModifyMode = false,
    required this.onCoverPhotoChanged,
    this.onVideoChanged,
  }) : super(key: key);

  @override
  _ImageUploadSectionState createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  bool _isVideo(String path) {
    return path.toLowerCase().endsWith('.mp4') || 
           path.toLowerCase().endsWith('.mov') || 
           path.toLowerCase().endsWith('.avi');
  }

  bool _isNetworkUrl(String path) {
    return path.startsWith('http');
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.error, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        widget.isModifyMode ?SizedBox(height: height*.02,):   Padding(
          padding: EdgeInsets.symmetric(vertical: height * .01),
          child: const Center(
            child: Text(
              "Upload Your up to 15 Photos and 1 Video ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Cover Image Preview
        if (widget.coverImage != null && widget.coverImage!.isNotEmpty)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height * .35,
                child: GestureDetector(
                  onTap: widget.isModifyMode ? () async {
                    print('DEBUG: Cover photo tapped in modify mode');
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      print('DEBUG: Image selected: ${image.path}');
                      widget.onCoverChanged(image.path);
                      widget.onCoverPhotoChanged(true);
                    } else {
                      print('DEBUG: No image selected');
                    }
                  } : null,
                  child: _isVideo(widget.coverImage!)
                      ? VideoPlayerWidget(
                    videoPath: widget.coverImage!,
                    autoPlay: true,
                    looping: true,
                  )
                      : _isNetworkUrl(widget.coverImage!)
                      ? Image.network(
                    widget.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                      : Image.file(
                    File(widget.coverImage!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  ),
                ),
              ),
              SizedBox(height: height * .02),
            ],
          ),
        ImagePickerField(
          imagePaths: widget.images,
          coverImage: widget.coverImage,
          videoPath: widget.videoPath,
          maxImages: 15,
          onImageSelected: widget.onImageSelected,
          onVideoSelected: widget.onVideoSelected,
          onCoverChanged: widget.onCoverChanged,
          onImageRemoved: widget.onImageRemoved,
          isModifyMode: widget.isModifyMode,
          onVideoChanged: widget.onVideoChanged,
        ),
      ],
    );
  }
}
