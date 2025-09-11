import 'dart:io';

import 'package:flutter/material.dart';

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

  const ImageUploadSection({
    Key? key,
    required this.images,
    required this.coverImage,
    required this.videoPath,
    required this.onImageSelected,
    required this.onVideoSelected,
    required this.onCoverChanged,
    required this.onImageRemoved,
  }) : super(key: key);

  @override
  _ImageUploadSectionState createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  bool _isVideo(String path) {
    if (path.isEmpty) return false;

    // Trim any query parameters or fragments from the path
    final cleanPath = path.split('?').first.split('#').first;

    // Get the file extension without the dot
    final fileName = cleanPath.split('/').last;
    if (!fileName.contains('.')) return false;

    final extension = fileName.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension);
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
        Padding(
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
                child: _isVideo(widget.coverImage!)
                    ? VideoPlayerWidget(
                  videoPath: widget.coverImage!,
                  autoPlay: true,
                  looping: true,
                )
                    : Image.file(
                  File(widget.coverImage!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
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
        ),
      ],
    );
  }
}
