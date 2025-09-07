import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/add_options_model.dart';




class AdvertisementOptionsModal extends StatefulWidget {
  final VoidCallback onShowroomAdPressed;
  final VoidCallback onPersonalAdPressed;

  const AdvertisementOptionsModal({
    Key? key,
    required this.onShowroomAdPressed,
    required this.onPersonalAdPressed,
  }) : super(key: key);

  @override
  _AdvertisementOptionsModalState createState() => _AdvertisementOptionsModalState();
}

class _AdvertisementOptionsModalState extends State<AdvertisementOptionsModal> {
  late List<OptionItem> showroomOptions;
  late List<OptionItem> personalOptions;

  @override
  void initState() {
    super.initState();
    showroomOptions = [
      OptionItem(text: "Free Ads",isChecked: true),
      OptionItem(text: "Free 360 shooting session",isChecked: true),
      OptionItem(text: "1.8 % after sale on the sold price.",isChecked: true),
      OptionItem(text: "Seller information stay private (Buyers can't see your contact details).",isChecked: true),
    ];

    personalOptions = [
      OptionItem(text: "Standard advertise.",isChecked: false),
      OptionItem(text: "People can see your contact details",isChecked: false),
      OptionItem(text: "You can upload pictures and video.",isChecked: false),
      OptionItem(text: "Optional 360 Shooting session.",isChecked: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Container(
      //  height: height*.7,
      margin: EdgeInsets.symmetric(horizontal: width*.04),
      decoration: BoxDecoration(
        color: Colors.white, // 👈 خلفية واضحة للكروت
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              width: width,
              height: height,
              title: "Qars Spin Showroom Advertisement",
              options: showroomOptions,
              buttonText: "Request appointment",
              onPressed: () {
                // final checkedOptions = showroomOptions.where((opt) => opt.isChecked).toList();
                // debugPrint('Checked options: ${checkedOptions.map((e) => e.text).toList()}');
                widget.onShowroomAdPressed();
              },
              icon: 'assets/images/calender.svg',
              onOptionToggled: (index) {
                setState(() {
                  //         showroomOptions[index].toggle();
                });
              },
            ),
            SizedBox(height: height*.02),
            _buildCard(
              width: width,
              height: height,
              title: "Free Personal Advertisement",
              options: personalOptions,
              buttonText: "Post your ad",
              onPressed: () {
                // final checkedOptions = personalOptions.where((opt) => opt.isChecked).toList();
                // debugPrint('Checked options: ${checkedOptions.map((e) => e.text).toList()}');
                widget.onPersonalAdPressed();
              },
              icon: "assets/images/plus.svg",
              onOptionToggled: (index) {
                setState(() {
                  personalOptions[index].toggle();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required List<OptionItem> options,
    required String buttonText,
    required VoidCallback onPressed,
    required double width,
    required double height,
    required String icon,
    required Function(int) onOptionToggled,
  }) {
    return Card(
      margin: EdgeInsets.only(top: height*.004), // ✅ يمنع أي فراغ خارجي

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      clipBehavior: Clip.antiAlias, // 👈 مهم جداً

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12), // هنا الحل، padding للعنوان
            width: double.infinity,
            color: Color(0xff7b7b7b),

            child: Center(
              child: Text(
                title,
                style:  TextStyle(
                  fontSize: width*.035 ,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal:width*.04),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height*.01),
                ...options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  return GestureDetector(
                    onTap: () => onOptionToggled(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          option.isChecked ?    Icon(
                            Icons.check_box ,
                            color:  Colors.green,
                            size: 20,
                          ):Container(
                            margin: EdgeInsets.only(left: width*.007),
                            color: Colors.black,width: width*.04,height: height*.02,),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              option.text,
                              style: TextStyle(
                                fontSize: width * 0.034,
                                fontWeight: FontWeight.bold,
                                color:  Colors.black,
                                decoration: option.isChecked ? null : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: height*.01),
                Center(
                  child: SizedBox(width: width*.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xfff6c42d),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onPressed,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            icon,
                            width: width * .053,

                          ),SizedBox(width: width*.02,),
                          Text(buttonText,style: TextStyle(color: Colors.black,fontSize: width*.04,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}