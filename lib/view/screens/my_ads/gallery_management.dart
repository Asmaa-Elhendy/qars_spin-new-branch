import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/my_ads/my_ad_getx_controller.dart';
import 'package:qarsspin/model/post_media.dart';

import '../../../controller/ads/data_layer.dart';

class GalleryManagement extends StatefulWidget {
int postId;
GalleryManagement({required this.postId});

  @override
  State<GalleryManagement> createState() => _GalleryManagementState();
}

class _GalleryManagementState extends State<GalleryManagement> {
  final ImagePicker _picker = ImagePicker();
  final MyAdCleanController controller = Get.find<MyAdCleanController>();
  List<File> images = [];
  List<MediaItem> apiImages = [];

  Future<void> _pickImages() async {
    final totalImages = images.length + (controller.postMedia.value?.data.length ?? 0);
    if (totalImages >= 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only select up to 15 images.")),
      );
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      for (var file in pickedFiles) {
        final editedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEditor(
              image: File(file.path).readAsBytesSync(),
            ),
          ),
        );

        if (editedImage != null) {
          // Create the file with edited image
          final imageFile = File(file.path)..writeAsBytesSync(editedImage);
          
          // Upload to API
          final success = await _uploadImageToApi(imageFile);
          
          if (success) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Photo uploaded successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Show error message - image is NOT added to list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Upload failed: ${controller.uploadError.value ?? 'Unknown error'}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  Future<bool> _uploadImageToApi(File imageFile) async {

    try {
      final success = await controller.uploadPostGalleryPhoto(
        postId: widget.postId.toString(),
        photoFile: imageFile,
        ourSecret: ourSecret,
      );
      return success;//f
    } catch (e) {
      print('❌ Error uploading image: $e');
      return false;
    }
  }
  void _swapImages(int oldIndex, int newIndex) {
    if (newIndex < 0 || newIndex >= images.length) return;
    setState(() {
      final temp = images[oldIndex];
      images[oldIndex] = images[newIndex];
      images[newIndex] = temp;
    });
  }

  void _swapApiImages(int oldIndex, int newIndex) {
    final apiImages = controller.postMedia.value?.data ?? [];
    if (newIndex < 0 || newIndex >= apiImages.length) return;
    
    setState(() {
      final temp = apiImages[oldIndex];
      apiImages[oldIndex] = apiImages[newIndex];
      apiImages[newIndex] = temp;
      
      // Update the controller's postMedia to reflect the change
      if (controller.postMedia.value != null) {
        final updatedPostMedia = PostMedia(
          code: controller.postMedia.value!.code,
          desc: controller.postMedia.value!.desc,
          count: controller.postMedia.value!.count,
          data: List<MediaItem>.from(apiImages),
        );
        controller.postMedia.value = updatedPostMedia;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPostImages();
  }

  Future<void> _fetchPostImages() async {
    print('Fetching images for post ID: ${widget.postId}');
    await controller.fetchPostMedia(widget.postId.toString());
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Image'),
        content: Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel' ,style: TextStyle(color: AppColors.textPrimary),)
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete',style: TextStyle(color: AppColors.brandBlue)),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _deleteApiImage(String mediaId) async {
    try {
      final success = await controller.deletePostGalleryPhoto(
        mediaId: mediaId,
        postId: widget.postId.toString(),
        ourSecret: '1244', // Using the same secret as other API calls
      );
      return success;
    } catch (e) {
      print('❌ Error deleting API image: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Header
          Container(
            height: 106.h,
            padding: EdgeInsets.only(top: 13.h, left: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.h,spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              spacing: 66.w,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_outlined,
                      color: Colors.black, size: 30.w),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Gallery Management",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Obx(() {
                      final totalImages = images.length + (controller.postMedia.value?.data.length ?? 0);
                      return Text(
                        "$totalImages of 15 images",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: fontFamily,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      );
                    }),
                  ],
                ),
                InkWell(
                  onTap: _pickImages,
                  child: Image.asset("assets/images/add.png", scale: 25.w),
                )
              ],
            ),
          ),

          40.verticalSpace,


          /// Images List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMedia.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.mediaError.value != null) {
                return Center(
                  child: Text(
                    'Error loading images: ${controller.mediaError.value}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final apiImages = controller.postMedia.value?.data ?? [];
              final allImages = [
                ...apiImages.map((mediaItem) => _buildApiImageItem(mediaItem)),
                ...images.map((file) => _buildLocalImageItem(file)),
              ];

              if (allImages.isEmpty) {
                return Center(
                  child: Text('No images found'),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: allImages.length,
                separatorBuilder: (_, __) => 16.verticalSpace,
                itemBuilder: (context, index) {
                  return allImages[index];
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildApiImageItem(MediaItem mediaItem) {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          /// Network Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                mediaItem.mediaUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          
          /// Delete Icon
          Positioned(
            right: 8.w,
            top: 8.h,
            child: GestureDetector(
              onTap: () async {
                final apiImages = controller.postMedia.value?.data ?? [];
                final index = apiImages.indexOf(mediaItem);
                if (index != -1) {
                  // Show confirmation dialog
                  final shouldDelete = await _showDeleteConfirmationDialog();
                  if (shouldDelete) {
                    final success = await _deleteApiImage(mediaItem.mediaId.toString());
                    if (success) {
                      // Remove from local list immediately for better UX
                      setState(() {
                        apiImages.removeAt(index);
                        // Update the controller's postMedia to reflect the change
                        if (controller.postMedia.value != null) {
                          final updatedPostMedia = PostMedia(
                            code: controller.postMedia.value!.code,
                            desc: controller.postMedia.value!.desc,
                            count: controller.postMedia.value!.count - 1,
                            data: List<MediaItem>.from(apiImages),
                          );
                          controller.postMedia.value = updatedPostMedia;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Image deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete image'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete, color: Colors.red, size: 20.w),
              ),
            ),
          ),

          /// Up Arrow
          Positioned(
            left: 8.w,
            top: 8.h,
            child: GestureDetector(
              onTap: () {
                final apiImages = controller.postMedia.value?.data ?? [];
                final index = apiImages.indexOf(mediaItem);
                if (index > 0) {
                  _swapApiImages(index, index - 1);
                }
              },
              child: Container(
                width: 40.w,
                height: 48.h,
                padding: EdgeInsets.all(12).r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset("assets/images/up-arrow.png"),
              ),
            ),
          ),

          /// Down Arrow
          Positioned(
            left: 8.w,
            bottom: 8.h,
            child: GestureDetector(
              onTap: () {
                final apiImages = controller.postMedia.value?.data ?? [];
                final index = apiImages.indexOf(mediaItem);
                if (index < apiImages.length - 1) {
                  _swapApiImages(index, index + 1);
                }
              },
              child: Container(
                width: 40.w,
                height: 48.h,
                padding: EdgeInsets.all(12).r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset("assets/images/down-arrow.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalImageItem(File image) {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          /// Delete Icon
          Positioned(
            right: 8.w,
            top: 8.h,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images.remove(image);
                });
              },
              child: Container(
                width: 40.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// Up Arrow
          Positioned(
            left: 8.w,
            top: 8.h,
            child: GestureDetector(
              onTap: () {
                final index = images.indexOf(image);
                if (index > 0) {
                  _swapImages(index, index - 1);
                }
              },
              child: Container(
                width: 40.w,
                height: 48.h,
                padding: EdgeInsets.all(12).r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset("assets/images/up-arrow.png"),
              ),
            ),
          ),

          /// Down Arrow
          Positioned(
            left: 8.w,
            bottom: 8.h,
            child: GestureDetector(
              onTap: () {
                final index = images.indexOf(image);
                if (index < images.length - 1) {
                  _swapImages(index, index + 1);
                }
              },
              child: Container(
                width: 40.w,
                height: 48.h,
                padding: EdgeInsets.all(12).r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset("assets/images/down-arrow.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
