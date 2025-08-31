import 'package:flutter/material.dart';
import 'package:untitled2/ads/presentation/widgets/adv_modal.dart';

import 'create_new_ad.dart';

class CreateNewAdOptions extends StatefulWidget {
  @override
  State<CreateNewAdOptions> createState() => _CreateNewAdOptionsState();
}

class _CreateNewAdOptionsState extends State<CreateNewAdOptions> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200),
            InkWell(
              onTap: () {
                setState(() {
                  show = true;
                });
              },
              child: const Center(child: Text('body')),
            ),
            show
                ? AdvertisementOptionsModal(
                    onShowroomAdPressed: () {},
                    onPersonalAdPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SellCarScreen(),
                        ),
                      );
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
