import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: width*.373,
          padding: EdgeInsets.zero,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: Colors.grey),
            label: const Text("Phone"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 👈 هنا تتحكم في الدوران
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(width: width*.373,
          padding: EdgeInsets.zero,

          child: ElevatedButton.icon(
            onPressed: () {},
            icon:  Image.asset("assets/images/call.png",width: width*.04,height:height*.02),
            label: const Text("Whatsapp"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 👈 هنا تتحكم في الدوران
              ),
            ),
          ),
        ),
      ],
    );
  }
}
