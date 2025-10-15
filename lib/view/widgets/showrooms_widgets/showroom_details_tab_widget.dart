import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowroomDetailsTabWidget extends StatefulWidget {
  const ShowroomDetailsTabWidget({super.key});

  @override
  State<ShowroomDetailsTabWidget> createState() => _ShowroomDetailsTabWidgetState();
}

class _ShowroomDetailsTabWidgetState extends State<ShowroomDetailsTabWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: width*.03,vertical: height*.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About " ,style: TextStyle(fontSize: width*.04,fontWeight: FontWeight.bold),),
          Divider(thickness: 2),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: height*.01),
            child: Text('Details '*20),
          ),
          Text("Location " ,style: TextStyle(fontSize: width*.04,fontWeight: FontWeight.bold),),
          Divider(thickness: 2),
      Center(
        child: Container(
          width: width * .8,
          height: height * .05,
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(12), // 👈 يخليها مستطيل مدوّر
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/map.svg",
                  width: width * .036,

                ),
                const SizedBox(width: 8),
                const Text(
                  'Salwa Road Branch',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      )

      ],
      ),
    );
  }
}
