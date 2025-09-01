import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../model/showroom_model.dart';

class ShowroomCard extends StatelessWidget {
  final Showroom showroom;
  bool carCare;
   ShowroomCard({super.key,required this.carCare, required this.showroom});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Stack(
            children: [
              // Logo
              Container(
                color: Colors.black,
                height: 100,
                width: double.infinity,
               // alignment: Alignment.center,
                child: Image.asset(
                  showroom.logoUrl,
                  fit: BoxFit.cover,
                  //height: 60,
                ),
              ),
              if (showroom.isFeatured)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Featured",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text("Details", style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 6),
              carCare?SizedBox() : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: Text("Cars (${showroom.carsCount})", style: const TextStyle(color: Colors.black)),
              ),
                Spacer(),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye, size: 18, color: Colors.blue),
                    const SizedBox(width: 2),
                    Text("${showroom.views}"),
                  ],
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text("${showroom.rating}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
