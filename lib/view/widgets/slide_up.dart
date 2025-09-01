// import 'package:flutter/material.dart';
//
// class SlideMenu extends StatefulWidget {
//   final Widget child;
//   final bool isVisible;
//   final Duration duration;
//   final Curve curve;
//   final Offset offset;
//   final VoidCallback? onSlideComplete;
//
//   const SlideMenu({
//     Key? key,
//     required this.child,
//     required this.isVisible,
//     this.duration = const Duration(milliseconds: 300),
//     this.curve = Curves.easeInOut,
//     this.offset = const Offset(0, 1), // Default slide up from bottom
//     this.onSlideComplete,
//   }) : super(key: key);
//
//   @override
//   _SlideMenuState createState() => _SlideMenuState();
// }
//
// class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     )..addStatusListener((status) {
//       if (status == AnimationStatus.completed ||
//           status == AnimationStatus.dismissed) {
//         widget.onSlideComplete?.call();
//       }
//     });
//
//     _offsetAnimation = Tween<Offset>(
//       begin: widget.offset,
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: widget.curve,
//     ));
//
//     if (widget.isVisible) {
//       _controller.forward();
//     }
//   }
//
//   @override
//   void didUpdateWidget(SlideMenu oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isVisible != oldWidget.isVisible) {
//       if (widget.isVisible) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _offsetAnimation,
//       builder: (context, child) {
//         return SlideTransition(
//           position: _offsetAnimation,
//           child:Column()// widget.child,
//         );
//       },
//     );
//   }
// }
//
// // Example usage:
// class CarsMenu extends StatelessWidget {
//   final bool isVisible;
//   final VoidCallback onClose;
//   final Function(String) onItemSelected;
//
//   const CarsMenu({
//     Key? key,
//     required this.isVisible,
//     required this.onClose,
//     required this.onItemSelected,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SlideMenu(
//       isVisible: isVisible,
//       offset: const Offset(0, 1), // Slide up from bottom
//       child: Material(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//         elevation: 8.0,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Drag handle
//             Container(
//               margin: const EdgeInsets.only(top: 8, bottom: 8),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             // Close button
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: onClose,
//               ),
//             ),
//             // Menu items
//             _buildMenuItem('All Cars', Icons.directions_car, () {
//               onItemSelected('all');
//               onClose();
//             }),
//             _buildMenuItem('Qars Spin Showroom', Icons.store, () {
//               onItemSelected('qars_spin');
//               onClose();
//             }),
//             _buildMenuItem('Showrooms', Icons.store_mall_directory, () {
//               onItemSelected('showrooms');
//               onClose();
//             }),
//             _buildMenuItem('Personal', Icons.person, () {
//               onItemSelected('personal');
//               onClose();
//             }),
//             const SizedBox(height: 24), // Bottom padding
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//     );
//   }
// }
