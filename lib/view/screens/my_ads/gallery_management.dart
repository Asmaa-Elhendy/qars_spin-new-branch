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
import '../../widgets/ads/dialogs/loading_dialog.dart';
import 'dart:developer';

class GalleryManagement extends StatefulWidget {
  final int postId;

  final String postKind;
  final String userName;

  GalleryManagement({
    required this.postId,

    required this.postKind,
    required this.userName,
  });

  @override
  State<GalleryManagement> createState() => _GalleryManagementState();
}

class _GalleryManagementState extends State<GalleryManagement> {
  final ImagePicker _picker = ImagePicker();
  final MyAdCleanController controller = Get.find<MyAdCleanController>();
  List<File> images = [];
  List<MediaItem> apiImages = [];
  String? currentCoverImage;
  Map<String, dynamic>? postDetails;

  Future<void> _pickImages() async {
    log('🚀 [DEBUG] _pickImages method started!');

    final totalImages =
        images.length + (controller.postMedia.value?.data.length ?? 0);
    if (totalImages >= 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only select up to 15 images.")),
      );
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    log(
      '🚀 [DEBUG] pickMultiImage completed. Files: ${pickedFiles?.length ?? 0}',
    );

    if (pickedFiles != null) {
      log('=== DEBUG: Selected ${pickedFiles.length} images ===');

      // STEP 1: Batch Editing - Edit all images first
      List<File> editedImages = [];

      log('=== STEP 1: Batch Editing Phase ===');
      for (int i = 0; i < pickedFiles.length; i++) {
        final file = pickedFiles[i];
        log(
          '🎨 [EDITING] Opening editor for image ${i + 1}/${pickedFiles.length}: ${file.path}',
        );

        // Edit the image
        log(
          '🎨 [EDITING] About to open ImageEditor for image ${i + 1}/${pickedFiles.length}',
        );
        log('🎨 [EDITING] Image file path: ${file.path}');
        log('🎨 [EDITING] Image file size: ${await file.length()} bytes');

        dynamic editedImage;
        try {
          // Show a snackbar to guide the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please edit image ${i + 1} and tap SAVE when done',
              ),
              duration: Duration(seconds: 3),
            ),
          );

          // Wait a bit for the snackbar to show
          await Future.delayed(Duration(milliseconds: 500));

          log('🎨 [EDITING] Opening ImageEditor dialog...');
          editedImage = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImageEditor(image: File(file.path).readAsBytesSync()),
            ),
          );
          log('🎨 [EDITING] Navigator.push completed successfully');
          log('🎨 [EDITING] User interaction completed - checking result...');
        } catch (e) {
          log('❌ [EDITING] Exception during ImageEditor navigation: $e');
          log('❌ [EDITING] Exception type: ${e.runtimeType}');
          editedImage = null;
        }

        log(
          '🎨 [EDITING] Returned from ImageEditor for image ${i + 1} - Result: ${editedImage != null ? "SUCCESS" : "CANCELLED"}',
        );
        log('🎨 [EDITING] Edited image type: ${editedImage?.runtimeType}');
        log(
          '🎨 [EDITING] Edited image size: ${editedImage?.length ?? 0} bytes',
        );

        // Additional check - sometimes ImageEditor returns empty list or invalid data
        // ImageEditor can return different types: List<int> or _Uint8ArrayView
        bool isValidImage =
            editedImage != null &&
            ((editedImage is List<int> && editedImage.isNotEmpty) ||
                (editedImage.toString().contains('Uint8Array') &&
                    editedImage.length > 0)) &&
            editedImage.length > 100; // At least 100 bytes

        log('🎨 [EDITING] Is valid image check: $isValidImage');

        if (!isValidImage && editedImage != null) {
          log(
            '⚠️ [EDITING] Image returned null or invalid data - treating as cancelled',
          );
        }

        if (isValidImage) {
          // Create the file with edited image
          // Convert _Uint8ArrayView to List<int> if needed
          List<int> imageBytes;
          if (editedImage is List<int>) {
            imageBytes = editedImage;
          } else {
            // Handle _Uint8ArrayView or other byte array types
            imageBytes = List<int>.from(editedImage);
          }

          final imageFile = File(file.path)..writeAsBytesSync(imageBytes);
          editedImages.add(imageFile);
          log('✅ [EDITING] Image ${i + 1} edited successfully');
          log(
            '✅ [EDITING] Converted ${editedImage.runtimeType} to List<int> (${imageBytes.length} bytes)',
          );
        } else {
          log('❌ [EDITING] Image ${i + 1} cancelled or invalid in editor');

          // Ask user if they want to retry
          bool shouldRetry = await _showRetryDialog(context, i + 1);
          if (shouldRetry) {
            log('🔄 [EDITING] Retrying image ${i + 1}...');
            i--; // Retry the same image
          }
        }
      }

      log(
        '=== STEP 1 COMPLETE: ${editedImages.length} images ready for upload ===',
      );

      // STEP 2: Sequential Uploading - Upload each edited image one by one
      if (editedImages.isNotEmpty) {
        int successCount = 0;
        int failCount = 0;

        log('=== STEP 2: Sequential Upload Phase ===');
        log(
          '📊 [DEBUG] Starting upload loop for ${editedImages.length} images',
        );

        for (int i = 0; i < editedImages.length; i++) {
          final imageFile = editedImages[i];
          log(
            '📤 [UPLOADING] Starting upload for image ${i + 1}/${editedImages.length}: ${imageFile.path}',
          );

          // Show loader for this specific image
          controller.isLoadingMedia.value = true;
          log('⏳ [UPLOADING] Loader ON for image ${i + 1}');

          // Upload this single image with skipRefresh=true
          try {
            log(
              '⏳ [UPLOADING] Calling _uploadImageToApiWithSkipRefresh for image ${i + 1}',
            );
            final success = await _uploadImageToApiWithSkipRefresh(imageFile);
            log(
              '⏳ [UPLOADING] Completed _uploadImageToApiWithSkipRefresh for image ${i + 1} - Result: $success',
            );

            if (success) {
              successCount++;
              log(
                '✅ [UPLOADING] Image ${i + 1} uploaded successfully - Total success: $successCount',
              );
            } else {
              failCount++;
              log(
                '❌ [UPLOADING] Image ${i + 1} upload failed - Total failed: $failCount',
              );
            }
          } catch (e) {
            failCount++;
            log(
              '❌ [UPLOADING] Exception uploading image ${i + 1}: $e - Total failed: $failCount',
            );
          }

          // Hide loader after this image is done
          controller.isLoadingMedia.value = false;
          log('⏳ [UPLOADING] Loader OFF for image ${i + 1}');

          // Small delay before processing next image
          log('⏳ [UPLOADING] Waiting 500ms before next image...');
          await Future.delayed(const Duration(milliseconds: 500));
          log('⏳ [UPLOADING] Delay completed, moving to next image if any');
        }

        log(
          '=== STEP 2 COMPLETE: Upload results - Success: $successCount, Failed: $failCount ===',
        );

        // Show final result message
        if (successCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Successfully uploaded $successCount image${successCount > 1 ? 's' : ''}!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (failCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to upload $failCount image${failCount > 1 ? 's' : ''}",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }

        // Final refresh to make sure everything is up to date (ONLY ONCE at the end)
        if (successCount > 0) {
          log('🔄 [FINAL] Refreshing media list after all uploads...');
          await controller.fetchPostMedia(widget.postId.toString());
        }
      } else {
        log('=== STEP 2: No images to upload ===');
      }
    }
  }

  Future<bool> _showRetryDialog(BuildContext context, int imageNumber) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Image Editing Cancelled'),
            content: Text(
              'Image $imageNumber was cancelled. Do you want to retry editing it?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Skip', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Retry',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _uploadImageToApiWithSkipRefresh(File imageFile) async {
    log('🔍 Starting upload with skipRefresh for: ${imageFile.path}'); //lhjjن

    try {
      log(
        '📤 Calling controller.uploadPostGalleryPhoto with skipRefresh=true...',
      );
      final success = await controller.uploadPostGalleryPhoto(
        postId: widget.postId.toString(),
        photoFile: imageFile,
        ourSecret: ourSecret,
        skipRefresh: true, // Skip refresh after each upload
      );

      if (success) {//k
        log('✅ Upload SUCCESS for: ${imageFile.path}');
      } else {
        log('❌ Upload FAILED for: ${imageFile.path}');
      }

      return success;
    } catch (e) {
      log('❌ EXCEPTION during upload for ${imageFile.path}: $e');
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
    _fetchPostDetails();
  }

  // Method to load cover image from postDetails (similar to create_new_ad.dart)
  void _loadCoverImageFromPostDetails() {
    if (postDetails != null && postDetails!['Rectangle_Image_URL'] != null) {
      setState(() {
        // Set currentCoverImage equal to Rectangle_Image_URL from postDetails
        currentCoverImage = postDetails!['Rectangle_Image_URL'];
        
        // Also set widget.coverImage equal to Rectangle_Image_URL
        // Note: widget.coverImage is final, so we can't modify it directly
        // But currentCoverImage is now synchronized with the latest Rectangle_Image_URL
      });
      log('✅ [DEBUG] Cover image set from postDetails: $currentCoverImage');
      log('✅ [DEBUG] Rectangle_Image_URL: ${postDetails!['Rectangle_Image_URL']}');
    }
  }

  Future<void> _fetchPostImages() async {
    log('Fetching images for post ID: ${widget.postId}');
    await controller.fetchPostMedia(widget.postId.toString());
  }

  Future<void> _fetchPostDetails() async {
    log('🚀 [DEBUG] Fetching post details for post ID: ${widget.postId}');
    log('🚀 [DEBUG] Post Kind: ${widget.postKind}');
    log('🚀 [DEBUG] User Name: ${widget.userName}');
    
    try {
      // Fetch complete post details using getPostById
      await controller.getPostById(
        postKind: widget.postKind,
        postId: widget.postId.toString(),
        loggedInUser: widget.userName,
      );
      
      // Check if post details were fetched successfully
      if (controller.postDetails.value != null) {
        log('✅ [DEBUG] Post details fetched successfully');
        log('✅ [DEBUG] Post details: ${controller.postDetails.value}');
        
        // Store post details in local variable
        setState(() {
          postDetails = controller.postDetails.value;
        });
        
        // Load cover image from postDetails (similar to create_new_ad.dart)
        _loadCoverImageFromPostDetails();
        
        // Now fetch the media/images for this post
        await controller.fetchPostMedia(widget.postId.toString());
        
        log('✅ [DEBUG] Post media fetched successfully');
      } else {
        log('❌ [DEBUG] Failed to fetch post details');
        // Fallback to just fetching media if post details fail
        await controller.fetchPostMedia(widget.postId.toString());
      }
    } catch (e) {
      log('❌ [DEBUG] Error fetching post details: $e');
      // Fallback to just fetching media if there's an error
      await controller.fetchPostMedia(widget.postId.toString());
    }
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
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColors.brandBlue),
                ),
              ),
            ],
          ),
        ) ??
        false;
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
      log('❌ Error deleting API image: $e');
      return false;
    }
  }


  /// Pick cover image from gallery
  Future<void> _pickCoverImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        await _uploadAndSetCoverImage(imageFile);
      }
    } catch (e) {
      log('❌ Error picking image from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image from gallery'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Upload image and set as cover
  Future<void> _uploadAndSetCoverImage(File imageFile) async {
    try {
      // Show loading indicator
      controller.isLoadingMedia.value = true;
      
      // Upload the cover image using the new method
      final uploadSuccess = await controller.uploadCoverImage(
        postId: widget.postId.toString(),
        photoFile: imageFile,
        ourSecret: ourSecret,
      );
      
      if (!uploadSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload cover image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // After successful upload, the media list is already refreshed
      // Get the latest uploaded image (should be the last one)
      final updatedApiImages = controller.postMedia.value?.data ?? [];
      String newCoverUrl = '';
      
      if (updatedApiImages.isNotEmpty) {
        newCoverUrl = updatedApiImages.last.mediaUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not get uploaded image URL'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Update the cover image using the controller method
      final updateSuccess = await controller.updateCoverImage(
        postId: widget.postId.toString(),
        newCoverImageUrl: newCoverUrl,
        ourSecret: ourSecret,
      );
      
      if (updateSuccess) {
        // Update the local cover image state directly without refreshing media
        setState(() {
          currentCoverImage = newCoverUrl;
        });
        
        // Only refresh post details to get the latest Rectangle_Image_URL
        // No need to refresh media since we already have the new cover URL
        await _fetchPostDetails();
        
        log('✅ [DEBUG] Cover image updated locally: $currentCoverImage');
        log('✅ [DEBUG] Skipped media refresh for better performance');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cover image updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cover image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log('❌ Error uploading and setting cover image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while updating cover image'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      controller.isLoadingMedia.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
                      blurRadius: 5.h,
                      spreadRadius: 1,
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
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black,
                        size: 30.w,
                      ),
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
                          final totalImages =
                              images.length +
                              (controller.postMedia.value?.data.length ?? 0);
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
                    ),
                  ],
                ),
              ),

              10.verticalSpace,

            //  16.verticalSpace,

              /// Images List
              Expanded(
                child: Obx(() {
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
                    ...apiImages.map(
                      (mediaItem) => _buildApiImageItem(mediaItem),
                    ),
                    ...images.map((file) => _buildLocalImageItem(file)),
                  ];

                  // Show cover image even if media list is empty
                  if (allImages.isEmpty && currentCoverImage != null && currentCoverImage!.isNotEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 1, // Only show cover image
                      separatorBuilder: (_, __) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        return _buildApiImageItem(MediaItem(
                          mediaId: 0,
                          mediaFileName: 'CoverPhotoForPostGalleryManagement',
                          mediaUrl: currentCoverImage!,
                          displayOrder: 0,
                        ),
                      );
                      },
                    );
                  }
                  
                  // Show "No images found" only if no cover image either
                  if (allImages.isEmpty && (currentCoverImage == null || currentCoverImage!.isEmpty)) {
                    return Center(child: Text('No images found'));
                  }

                  // Only show cover image if it exists
                  if (currentCoverImage != null && currentCoverImage!.isNotEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: allImages.length+1,
                      separatorBuilder: (_, __) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        if (index==0){
                          return   _buildApiImageItem(MediaItem(
                              mediaId: 0,//ljت
                              mediaFileName: 'CoverPhotoForPostGalleryManagement',
                              mediaUrl: currentCoverImage!,
                              displayOrder: 0,
                            ),
                          );
                        }
                        return allImages[index - 1];
                      },
                    );
                  } else {
                    // Show only gallery images without cover image
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: allImages.length,
                      separatorBuilder: (_, __) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        return allImages[index];
                      },
                    );
                  }
                }),
              ),
            ],
          ),

          /// 🌟 Global Loader يغطي الشاشة كلها زي SpecsManagement
          Obx(() {
            if (controller.isLoadingMedia.value) {
              return Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: AppLoadingWidget(
                      //kj
                      title: 'Loading...\nPlease Wait...',
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildApiImageItem(MediaItem mediaItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mediaItem.mediaFileName == 'CoverPhotoForPostGalleryManagement')
          Stack(
            children: [
              Image.asset("assets/images/featured.png"),
              Positioned(
                left: 20.w,
                child: Center(
                  child: const Text(
                    "Cover",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              width: 2,
              color:
                  mediaItem.mediaFileName ==
                      'CoverPhotoForPostGalleryManagement'
                  ? AppColors.danger
                  : Colors.grey,
            ),
          ),
          child: Stack(
            children: [
              /// Network Imagehkنه
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
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
              (mediaItem.mediaFileName == 'CoverPhotoForPostGalleryManagement')
                  ? Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: GestureDetector(
                        onTap: () async {
                          await _pickCoverImageFromGallery();
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xffEC6D64),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: GestureDetector(
                        onTap: () async {
                          final apiImages =
                              controller.postMedia.value?.data ?? [];
                          final index = apiImages.indexOf(mediaItem);
                          if (index != -1) {
                            // Show confirmation dialog
                            final shouldDelete =
                                await _showDeleteConfirmationDialog();
                            if (shouldDelete) {
                              final success = await _deleteApiImage(
                                mediaItem.mediaId.toString(),
                              );
                              if (success) {
                                // Remove from local list immediately for better UX
                                setState(() {
                                  apiImages.removeAt(index);
                                  // Update the controller's postMedia to reflect the change
                                  if (controller.postMedia.value != null) {
                                    final updatedPostMedia = PostMedia(
                                      code: controller.postMedia.value!.code,
                                      desc: controller.postMedia.value!.desc,
                                      count:
                                          controller.postMedia.value!.count - 1,
                                      data: List<MediaItem>.from(apiImages),
                                    );
                                    controller.postMedia.value =
                                        updatedPostMedia;
                                  }
                                });
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text('Image deleted successfully'),
                                //     backgroundColor: Colors.green,
                                //   ),
                                // );
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text('Failed to delete image'),
                                //     backgroundColor: Colors.red,
                                //   ),
                                //   );
                              }
                            }
                          }
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xffEC6D64),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                      ),
                    ),

              /// Up Arrow
              (mediaItem.mediaFileName == 'CoverPhotoForPostGalleryManagement')
                  ? SizedBox():     Positioned(
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
              (mediaItem.mediaFileName == 'CoverPhotoForPostGalleryManagement')
                  ? SizedBox():    Positioned(
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
        ),
      ],
    );
  }

  Widget _buildLocalImageItem(File image) {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
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
                height: 40.h,
                decoration: BoxDecoration(
                  color: Color(0xffEC6D64),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 28.w,
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
