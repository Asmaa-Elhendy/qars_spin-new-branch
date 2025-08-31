import 'package:flutter/material.dart';

class RatingTabShowRoomDetail extends StatefulWidget {
  const RatingTabShowRoomDetail({super.key});

  @override
  State<RatingTabShowRoomDetail> createState() => _RatingTabShowRoomDetailState();
}

class _RatingTabShowRoomDetailState extends State<RatingTabShowRoomDetail> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text("User ratings here " ),
      ],
    );
  }
}
