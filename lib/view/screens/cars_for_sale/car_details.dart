import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/const/colors.dart';
import '../../../model/car_model.dart';
import '../../widgets/bottom_offer_bar.dart';
import '../../widgets/buttons/requesr_report_button.dart';
import '../../widgets/car_card.dart';
import '../../widgets/car_image.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../../widgets/offer_dialog.dart';
import '../../widgets/texts/texts.dart';

class CarDetails extends StatefulWidget {
  CarModel carModel;
   CarDetails({required this.carModel,super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  @override
  Widget build(BuildContext context) {
    List<CarModel> carsList = [
      // CarModel(
      //     id: 1,
      //     carModel: 'Camry 2021',
      //     carBrand: CarBrand(
      //       name: 'Toyota',
      //       imageUrl: '',
      //       make_count: 0
      //     ),
      //     status: CarStatus.Personal,
      //     image: 'assets/images/car1.png',
      //     kms: 45000.0,
      //     price: 228.00,
      //     modelYear: "2018"
      // ),
      // CarModel(
      //     id: 2,
      //     carModel: 'Civic 2022',
      //     carBrand: CarBrand(
      //       name: 'Honda',
      //       imageUrl: '',
      //         make_count: 0
      //     ),
      //     status: CarStatus.Showroom,
      //     image: 'assets/images/car3.png',
      //     kms: 15000.0,
      //     price: 3550.00,
      //     modelYear: "2008"
      // ),
      // CarModel(
      //     id: 3,
      //     carModel: 'Model 3 2023',
      //     carBrand: CarBrand(
      //       name: 'Tesla',
      //       imageUrl: '',
      //         make_count: 0
      //     ),
      //     status: CarStatus.QarsSpin,
      //     image: 'assets/images/car4.png',
      //     kms: 5000.0,
      //     price: 4550,
      //     modelYear: "2005"
      // ),
      // CarModel(
      //     id: 4,
      //     carModel: 'Corvette 2020',
      //     carBrand: CarBrand(
      //       name: 'Chevrolet',
      //       imageUrl: '',
      //         make_count: 0
      //     ),
      //     status: CarStatus.Personal,
      //     image: 'assets/images/car2.png',
      //     kms: 30000.0,
      //     price: 68.00,
      //     modelYear: "2020"
      // ),

    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomActionBar(
        onMakeOffer: ()async {
          // Handle make offer
          await showDialog(
          context: context,
          builder: (_) => const MakeOfferDialog(),
          );
        },
        onWhatsApp: () {
          // Handle WhatsApp
        },
        onCall: () {
          // Handle call
        },
      ),
   
      appBar: carListAppBar(notificationCount: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            children: [
              carImage(widget.carModel.rectangleImageUrl),
              8.verticalSpace,
              blueText("66 people viewed this car"),
              4.verticalSpace,
              headerText(widget.carModel.carNamePl),
              4.verticalSpace,
              description("description"),
              Divider(thickness: .5,color: Colors.black,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    greyText("Price"),
                    2.verticalSpace,
                    price("${widget.carModel.askingPrice} QAR"),
                    2.verticalSpace,
                    boldGrey("4 People made an offer on this car")
                  ],
                ),
              ),
              Divider(thickness: .5,color: Colors.black,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 70.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
        
        
        
                  children: [
                    Column(
                      children: [
                        boldGrey("AD Code"),
                        4.verticalSpace,
                        headerText(widget.carModel.postCode),
        
                      ],
                    ),
                    Column(
                      children: [
                        boldGrey("Year"),
                        4.verticalSpace,
                        headerText("${widget.carModel.manufactureYear}"),
        
                      ],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 70.w),
        
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        boldGrey("Mileage"),
                       4.verticalSpace,
                        headerText(widget.carModel.mileage.toString()),
        
                      ],
                    ),
                    Column(
                      children: [
                        boldGrey("Warranty"),
                       4.verticalSpace,
                        headerText("No"),
        
                      ],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
        
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 70.w),
        
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        boldGrey("Exterior"),
                       4.verticalSpace,
                       Container(
                         width: 34,
                         height: 34,
                         decoration:BoxDecoration(
                           shape: BoxShape.circle,
                           color: Colors.red
                         ),
                       )
        
                      ],
                    ),
                    Column(
                      children: [
                        boldGrey("interior"),
                        4.verticalSpace,
                        Container(
                          width: 34,
                          height: 34,
                          decoration:BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            border: Border.all(
                              color: AppColors.darkGray
                            )
                          ),
                        )
        
        
                      ],
                    ),
        
                  ],
                ),
              ),
              16.verticalSpace,
              Center(child: requestReportButton()),
              16.verticalSpace,
              Column(
                children: [
                  sectionWithCars("Similar Cars",carsList),
                  18.verticalSpace,
                  sectionWithCars("Owner's Ads",carsList),
                ],
              ),
              16.verticalSpace




            ],
          ),
        ),
      ),

    );
  }
  Widget sectionWithCars(String title, List<CarModel> cars) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 25.h),
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
              separatorBuilder: (_, __) =>  SizedBox(width: 18.w),
              itemBuilder: (context, index) {
                return SizedBox(
                //  width: 200, // card width
                 // height: 30.h,
                  child: carCard(
                    w: 195.w,
                    h: 1.h,
                    car: cars[index],
                    large: false,
                    tooSmall: true
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
