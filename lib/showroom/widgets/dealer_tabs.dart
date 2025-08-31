import 'package:flutter/material.dart';

class DealerTabs extends StatelessWidget {
  const DealerTabs({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              height:height*.04,
              color: const Color(0xfff6c42d), // ✅ الخلفية الأصفر
              child: TabBar(
                indicator: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,          // النص جوه الأبيض
                tabs: const [
                  Tab(text: "Gallery"),
                  Tab(text: "Details"),
                  Tab(text: "Rating"),
                ],
              ),
            ),



            Expanded(
              child: TabBarView(
                children: [
                  // ✅ Gallery tab (3 عربيات جنب بعض)
                  GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 👈 3 عربيات في الصف
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9, // عدد العربيات
                    itemBuilder: (_, i) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/car1.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),

                  // Details tab
                  ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text("Car details here " * 20),
                    ],
                  ),

                  // Rating tab
                  ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text("User ratings here " * 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
