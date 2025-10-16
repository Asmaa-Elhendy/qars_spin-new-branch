import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget carImage(List<String> allImages) {
  final PageController controller = PageController();

  return StatefulBuilder(
    builder: (context, setState) {
      int currentIndex = 0;

      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 250.h,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                final imageUrl = allImages[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 250.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 250.h,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                    // loadingBuilder: (context, child, loadingProgress) {
                    //   if (loadingProgress == null) return child;
                    //   return Container(
                    //     width: double.infinity,
                    //     height: 250.h,
                    //     alignment: Alignment.center,
                    //     child:
                    //     const CircularProgressIndicator(strokeWidth: 2),
                    //   );
                    // },
                  ),
                );
              },
            ),
          ),

          // Left arrow (show only if not first image)
          if (currentIndex > 0)
            Positioned(
              left: 10,
              child: _arrowButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

          // Right arrow (show only if not last image)
          if (currentIndex < allImages.length - 1)
            Positioned(
              right: 10,
              child: _arrowButton(
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      );
    },
  );
}

Widget _arrowButton({required IconData icon, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// Widget carImage(List<String> allImages){
//   return Container(
//     width: double.infinity,
//     height: 250.h,
//    child: ListView.separated(
//       scrollDirection: Axis.horizontal,
//       itemCount: allImages.length,
//       separatorBuilder: (_, __) => const SizedBox(width: 8),
//       itemBuilder: (context, index) {
//         final imageUrl = allImages[index];
//
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Image.network(
//             imageUrl,
//             width: 250,
//             height: 180,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) => Container(
//               width: 250,
//               height: 180,
//               color: Colors.grey.shade200,
//               alignment: Alignment.center,
//               child: const Icon(Icons.image_not_supported, color: Colors.grey),
//             ),
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Container(
//                 width: 250,
//                 height: 180,
//                 alignment: Alignment.center,
//                 child: const CircularProgressIndicator(strokeWidth: 2),
//               );
//             },
//           ),
//         );
//       },
//     ),
//     // child: Image.network(path,
//     // fit: BoxFit.cover,
//     //   errorBuilder: (context, error, stackTrace) => Container(
//     //     height: 150,
//     //     width: double.infinity,
//     //     color: Colors.grey.shade200,
//     //     alignment: Alignment.center,
//     //     child: const Icon(Icons.image_not_supported, color: Colors.grey),
//     //   ),
//     //   // loadingBuilder: (context, child, loadingProgress) {
//     //   //   if (loadingProgress == null) return child;
//     //   //   return Container(
//     //   //     height: 160,
//     //   //     width: double.infinity,
//     //   //     alignment: Alignment.center,
//     //   //     child: const CircularProgressIndicator(strokeWidth: 2),
//     //   //   );
//     //   // },
//     //
//     // ),
//   );
//
//
// }