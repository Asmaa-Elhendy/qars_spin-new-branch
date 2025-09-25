import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/view/screens/get_loan.dart';
import 'package:qarsspin/view/widgets/car_details/qars_apin_bottom_navigation_bar.dart';
import '../../../controller/const/colors.dart';
import '../../../model/car_model.dart';
import '../../widgets/bottom_offer_bar.dart';
import '../../widgets/buttons/requesr_report_button.dart';
import '../../widgets/car_card.dart';
import '../../widgets/car_details/tab_bar.dart';
import '../../widgets/car_image.dart';
import '../../widgets/offer_dialog.dart';
import '../../widgets/texts/texts.dart';

class CarDetails extends StatefulWidget {
  String postKind;
  int id;
  CarDetails({required this.id,required this.postKind,super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  bool isFav = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    print("source${widget.postKind}");
  }
  @override
  Widget build(BuildContext context) {
    List<CarModel> carsList = [];

    return GetBuilder<BrandController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.white,
        bottomNavigationBar: widget.postKind == "Qars Spin"
            ? QarsApinBottomNavigationBar(
          onLoan: (){
            Get.to(GetLoan(car: controller.carDetails));
          },
          onMakeOffer: ()async {
            // Handle make offer
            await showDialog(
              context: context,
              builder: (_) =>  MakeOfferDialog(),
            );
          },
          onRequestToBuy: ()async {
            // Handle make offer
            await showDialog(
              context: context,
              builder: (_) =>  MakeOfferDialog(offer: false,requestToBuy: true,price: controller.carDetails.askingPrice,),
            );


          },
        )
            : BottomActionBar(
          onMakeOffer: () async {
            // Handle make offer

            await showDialog(
              context: context,
              builder: (_) =>  MakeOfferDialog(),
            );
          },
          onWhatsApp: () {
            // Handle WhatsApp
          },
          onCall: () {
            // Handle call
          },
        ),
        body: Column(children: [
          Container(
            height: 88.h, // same as your AppBar height
            padding: EdgeInsets.only(top: 13.h, left: 14.w, right: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // shadow color
                  blurRadius: 6, // softens the shadow
                  offset: Offset(0, 2), // moves shadow downward
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // go back
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 30.w,
                  ),
                ),
                .5.horizontalSpace,
                Center(
                  child: SizedBox(
                      width: 147.w,
                      child: Image.asset(
                        "assets/images/black_logo.png",
                        fit: BoxFit.cover,
                      )),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                          width: 25.w,
                          child: Image.asset(
                            "assets/images/share.png",
                            fit: BoxFit.cover,
                          )),
                    ),
                    12.horizontalSpace,
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                      child: isFav
                          ? Icon(
                        Icons.favorite,
                        color: AppColors.star,
                      )
                          : Icon(Icons.favorite_border),
                    )
                  ],
                ),
              ],
            ),
          ),
          carImage(controller.carDetails.rectangleImageUrl),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: SizedBox(
                      //height: 800.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize
                            .min, // shrink-wrap instead of expanding
                        children: [
                          blueText(
                              "${controller.carDetails.visitsCount} people viewed this car"),
                          4.verticalSpace,
                          headerText(controller.carDetails.carNamePl),
                          4.verticalSpace,
                          description(controller.carDetails.description),
                          12.verticalSpace,
                          Divider(
                            thickness: .5,
                            color: Colors.black,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                greyText("Price"),
                                2.verticalSpace,
                                price(
                                    "${controller.carDetails.askingPrice} QAR"),
                                2.verticalSpace,
                                boldGrey(
                                    "${controller.carDetails.offersCount} People made an offer on this car")
                              ],
                            ),
                          ),
                          Divider(
                            thickness: .5,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    boldGrey("AD Code"),
                                    4.verticalSpace,
                                    headerText(controller.carDetails.postCode),
                                  ],
                                ),
                                Column(
                                  children: [
                                    boldGrey("Year"),
                                    4.verticalSpace,
                                    headerText(
                                        "${controller.carDetails.manufactureYear}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          30.verticalSpace,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    boldGrey("Mileage"),
                                    4.verticalSpace,
                                    headerText(controller.carDetails.mileage
                                        .toString()),
                                  ],
                                ),
                                Column(
                                  children: [
                                    boldGrey("Warranty"),
                                    4.verticalSpace,
                                    headerText(controller
                                        .carDetails.warrantyAvailable),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          30.verticalSpace,

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // shrink-wrap instead of expanding
                                  children: [
                                    boldGrey("Exterior"),
                                    4.verticalSpace,
                                    Container(
                                      width: 34.w,
                                      height: 34.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.darkGray),
                                          color: controller
                                              .carDetails.exteriorColor),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    boldGrey("interior"),
                                    4.verticalSpace,
                                    Container(
                                      width: 34.w,
                                      height: 34.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller
                                              .carDetails.interiorColor,
                                          border: Border.all(
                                              color: AppColors.darkGray)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                          controller.carDetails.sourceKind == 'Qars Spin'
                              ? Center(child: requestReportButton(context,widget.id))
                              : SizedBox(),
                          16.verticalSpace,
                          //optional Details
                          controller.carDetails.sourceKind == 'Individual' ||
                              controller.carDetails.sourceKind == 'Partner'
                              ? SizedBox(
                              height: 300.h,
                              child: CustomTabExample(
                                spec: controller.spec,
                                offers: controller.offers,
                              ))
                              : SizedBox(),
                          16.verticalSpace,

                          controller.carDetails.sourceKind == 'Qars Spin' ||
                              controller.carDetails.sourceKind == 'Partner'
                              ? Column(
                            children: [
                              sectionWithCars("Similar Cars", carsList),
                              18.verticalSpace,
                              sectionWithCars("Owner's Ads", carsList),
                            ],
                          )
                              : SizedBox(),
                          16.verticalSpace
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }

  Widget sectionWithCars(String title, List<CarModel> cars) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 285.h, // card height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cars.length,
              separatorBuilder: (_, __) => SizedBox(width: 18.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  //  width: 200, // card width
                  // height: 30.h,
                  child: carCard(
                      w: 195.w,
                      h: 1.h,
                      postKind: "",
                      car: cars[index],
                      large: false,
                      tooSmall: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
