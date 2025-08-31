import 'package:flutter/material.dart';

class DealerInfoSection extends StatelessWidget {
  const DealerInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/logo.png"),
          ),
          const SizedBox(width: 10),

          // Dealer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Car Dealer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Join date: 01/11/2024",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "123456",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Container(
                          margin: EdgeInsets.only(right: width * .02),
                          height: height * .04,
                          width: width * .25,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Center(
                              child: const Text(
                                "Follow",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Followers",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "123456",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [1, 2, 3, 4, 5]
                          .map((e) => const Icon(Icons.star, size: 16, color: Colors.amber))
                          .toList(),
                    )

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
