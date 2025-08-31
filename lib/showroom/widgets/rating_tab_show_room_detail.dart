import 'package:flutter/material.dart';

class RatingTabShowRoomDetail extends StatefulWidget {
  const RatingTabShowRoomDetail({super.key});

  @override
  State<RatingTabShowRoomDetail> createState() => _RatingTabShowRoomDetailState();
}

class _RatingTabShowRoomDetailState extends State<RatingTabShowRoomDetail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3, 4, 5]
              .map((e) => const Icon(Icons.star, size: 24, color: Color(0xFFF6C42D)))
              .toList(),
        ),
        SizedBox(height: height*.01,),
        Center(child: Text("123 Ratings",style: TextStyle(fontSize: width*.05,fontWeight: FontWeight.bold), )),
       Padding(
         padding:  EdgeInsets.symmetric(horizontal: width*.05),
         child: Row(
           children: [
             Expanded(
               child: Column(
                 children: [
                   RatingLine(width, height,'5',0.8),
                   RatingLine(width, height,'4',0.2),
                   RatingLine(width, height,'3',0.4),
                   RatingLine(width, height,'2',0.3),
                   RatingLine(width, height,'1',0.4),
                 ],
               ),
             ),SizedBox(width: width*.08,),
             Column(
               children: [
             Text("4.5",style: TextStyle(fontSize: width*.12,fontWeight: FontWeight.bold)),
             Text("Out of 5",style: TextStyle(fontSize: width*.04 ,fontWeight: FontWeight.bold))
               ],
             )
           ],
         ),
       )

      ],
    );
  }
}
Widget RatingLine(double width,double height,String text,double value){
  return       Row(
    children: [
      Text(
       text,
        style: TextStyle(fontSize: width * .05, fontWeight: FontWeight.bold),
      ),
      SizedBox(width: width * .01),
      Icon(Icons.star, size: 15, color: Color(0xFFF6C42D)),
      SizedBox(width: width * .02), // مسافة بسيطة قبل البار
      Expanded( // 👈 هنا يخلي البار ياخد باقي المساحة
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Color(0xfff2f2f2),
          minHeight: height * .01,
          borderRadius: BorderRadius.circular(10),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF6C42D)),
        ),
      ),
    ],
  );
}