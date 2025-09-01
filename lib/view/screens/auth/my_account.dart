import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled2/view/screens/auth/registration_screen.dart';
import '../../../controller/auth.dart';
import '../../../controller/const/colors.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.background,
          toolbarHeight: 60.h,
          shadowColor: Colors.grey.shade300,

          elevation: .4,

          title: Text(
            "My Account",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp
            ),
          )
      ),

      body:

      registered?bodyWithRegistered():bodyWithoutRegister(),
    );
  }
  Widget bodyWithoutRegister(){
  return  Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text(
              "Register Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
            onTap: () {
              Get.to(RegistrationScreen());
            },
          ),
        ),
        const SizedBox(height: 20),

        // Notifications
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.red),
          title: const Text(
            "Notifications",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.black54),
          onTap: () {

          },
        ),
      ],
    ),
  );

  }
  Widget bodyWithRegistered(){
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("sv4it",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("97433998885",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("01/01/1900"),
                    SizedBox(height: 8),
                    Text("Active Ads: 0",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // القايمة
        buildMenuItem(
          icon: Icons.notifications,
          title: "Notifications",
          iconColor: Colors.red,
        ),
        buildMenuItem(
          icon: Icons.local_offer,
          title: "My Offers",
        ),
        buildMenuItem(
          icon: Icons.campaign,
          title: "My Advertisements",
        ),
        buildMenuItem(
          icon: Icons.favorite,
          title: "My Favorites",
        ),
        buildMenuItem(
          icon: Icons.notifications_active,
          title: "Personalized Notifications",
        ),
        const SizedBox(height: 20),
        buildMenuItem(
          icon: Icons.logout,
          title: "Sign Out",
        ),
        buildMenuItem(
          icon: Icons.delete_outline,
          title: "Delete My Account",
        ),
      ],
    );
  }
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.black),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Image.asset("assets/images/arrow.png",scale: 1.8,),
          onTap: onTap,
        ),
        const Divider(height: 1, color: Colors.black26),
      ],
    );
  }
}
