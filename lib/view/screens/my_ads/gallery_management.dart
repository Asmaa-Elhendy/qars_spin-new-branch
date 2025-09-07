import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';

class GalleryManagement extends StatefulWidget {
  const GalleryManagement({super.key});

  @override
  State<GalleryManagement> createState() => _GalleryManagementState();
}

class _GalleryManagementState extends State<GalleryManagement> {
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];

  Future<void> _pickImages() async {
    if (images.length >= 15) {
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
          setState(() {
            if (images.length < 15) {
              images.add(File(file.path)..writeAsBytesSync(editedImage));
            }
          });
        }
      }
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
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
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
                    Text(
                      "${images.length} of 15 images",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: images.length,
              separatorBuilder: (_, __) => 16.verticalSpace,
              itemBuilder: (context, index) {
                final image = images[index];

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
                              images.removeAt(index);
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
                          onTap: () => _swapImages(index, index - 1),
                          child: Container(
                            width: 40.w,
                            height: 48.h,
                            padding: EdgeInsets.all(12).r,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:
                            Image.asset("assets/images/up-arrow.png"),
                          ),
                        ),
                      ),

                      /// Down Arrow
                      Positioned(
                        left: 8.w,
                        bottom: 8.h,
                        child: GestureDetector(
                          onTap: () => _swapImages(index, index + 1),
                          child: Container(
                            width: 40.w,
                            height: 48.h,
                            padding: EdgeInsets.all(12).r,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:
                            Image.asset("assets/images/down-arrow.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
