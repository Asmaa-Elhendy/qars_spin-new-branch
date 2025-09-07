import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:async';

class ImagePickerField extends StatefulWidget {
  final List<String> imagePaths;
  final String? coverImage;
  final String? videoPath;
  final int maxImages;
  final Function(String) onImageSelected;
  final Function(String)? onVideoSelected;
  final Function(String)? onCoverChanged;
  final Function(int)? onImageRemoved;
  final Function()? onVideoRemoved;

  const ImagePickerField({
    Key? key,
    required this.imagePaths,
    this.coverImage,
    this.videoPath,
    this.maxImages = 15,
    required this.onImageSelected,
    this.onVideoSelected,
    this.onCoverChanged,
    this.onImageRemoved,
    this.onVideoRemoved,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];
  String? _videoPath;
  String? _videoThumbnail;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.imagePaths);
    _videoPath = widget.videoPath;
    if (_videoPath != null && _videoPath!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadVideoThumbnail();
      });
    }
  }

  @override
  void didUpdateWidget(ImagePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update images if they've changed
    if (widget.imagePaths != oldWidget.imagePaths) {
      _images = List.from(widget.imagePaths);
    }
    
    // Update video if it's been removed
    if (widget.videoPath != oldWidget.videoPath) {
      _videoPath = widget.videoPath;
      if (_videoPath == null) {
        _videoThumbnail = null;
      } else if (_videoPath!.isNotEmpty) {
        _loadVideoThumbnail();
      }
    }
  }

  Future<void> _loadVideoThumbnail() async {
    if (_videoPath == null || _videoPath!.isEmpty) return;
    
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: _videoPath!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 50,
      );
      
      if (mounted && thumbnail != null) {
        setState(() {
          _videoThumbnail = thumbnail;
        });
      }
    } catch (e) {
      debugPrint('Error generating video thumbnail: $e');
    }
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    try {
      if (isVideo) {
        if (_videoPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only add one video')),
          );
          return;
        }

        final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
        );

        if (video != null) {
          widget.onVideoSelected?.call(video.path);
          setState(() {
            _videoPath = video.path;
            _loadVideoThumbnail();
            // Set video as cover when selected
            widget.onCoverChanged?.call(video.path);
          });
        }
      } else {
        if (_images.length >= widget.maxImages) return;
        
        if (_images.length >= widget.maxImages) return;
        
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );

        if (image != null) {
          widget.onImageSelected(image.path);
          setState(() {
            _images.add(image.path);
            // If this is the first media item, set it as cover
            if (widget.coverImage == null && _images.length == 1 && _videoPath == null) {
              widget.onCoverChanged?.call(image.path);
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }


  void _removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      setState(() {
        String removedImage = _images[index];
        _images.removeAt(index);
        widget.onImageRemoved?.call(index);

        // If the removed image was the cover, update the cover
        if (widget.coverImage == removedImage) {
          widget.onCoverChanged?.call(_images.isNotEmpty ? _images[0] : (_videoPath ?? ''));
        }
      });
    }
  }

  void _showMediaSelectionDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Add Media',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.black),
                title: const Text('Add Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(isVideo: false);
                },
              ),
              if (_videoPath == null)
                ListTile(
                  leading: const Icon(Icons.video_library, color: Colors.black),
                  title: const Text('Add Video'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(isVideo: true);
                  },
                ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    // Combine images and video into a single list for display
    List<Map<String, dynamic>> mediaItems = [];
    
    // Add video first if exists
    if (_videoPath != null) {
      mediaItems.add({
        'path': _videoPath!,
        'isVideo': true,
        'thumbnail': _videoThumbnail
      });
    }
    
    // Add all images
    for (var imgPath in _images) {
      mediaItems.add({
        'path': imgPath,
        'isVideo': false,
      });
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...mediaItems.asMap().entries.map((entry) {
          final index = entry.key;
          final media = entry.value;
          final isVideo = media['isVideo'] as bool;
          final path = media['path'] as String;
          // Check if this media item is the cover (either image or video)
          final bool isCover = path == widget.coverImage || 
                             (isVideo && _videoPath == widget.coverImage);
          final thumbnail = media['thumbnail'] as String?;

          return Stack(
            children: [
              Container(
                width: width * .2,
                height: width * .2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  image: DecorationImage(
                    image: isVideo && thumbnail != null 
                      ? FileImage(File(thumbnail))
                      : FileImage(File(path)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: isVideo 
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                  : null,
              ),
              if (widget.onCoverChanged != null && isCover)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => widget.onCoverChanged?.call(path),
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
                  onTap: () {
                    if (isVideo) {
                      final wasCover = _videoPath == widget.coverImage;
                      widget.onVideoRemoved?.call();
                      setState(() {
                        _videoPath = null;
                        _videoThumbnail = null;
                        if (wasCover) {
                          // If video was cover, set first image as cover or clear if no images
                          widget.onCoverChanged?.call(_images.isNotEmpty ? _images[0] : '');
                        }
                      });
                    } else {
                      final imgIndex = _images.indexOf(path);
                      if (imgIndex != -1) {
                        _removeImage(imgIndex);
                      }
                    }
                  },
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
              // Make the whole media item tappable to set as cover
              if (widget.onCoverChanged != null && !isCover)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onCoverChanged?.call(path),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
        if (mediaItems.length < (widget.maxImages + (_videoPath != null ? 1 : 0)))
          GestureDetector(
            onTap: _showMediaSelectionDialog,
            child: Container(
              width: width * .2,
              height: width * .2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
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
