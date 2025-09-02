import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/brand_controller.dart';
import '../../controller/const/colors.dart';
import '../../controller/rental_cars_controller.dart';
import '../widgets/ad_container.dart';
import '../widgets/main_card.dart';
import '../widgets/navigation_bar.dart';
import 'ads/create_new_ad.dart';
import 'auth/my_account.dart';
import 'cars_for_rent/all_rental_cars.dart';
import 'cars_for_sale/all_cars.dart';
import 'cars_for_sale/cars_brand_list.dart';
import 'cars_for_sale/showrooms.dart';
import 'favourites/presentation/pages/favourite_screen.dart';
import 'general/contact_us.dart';
import 'general/main_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int notificationCount = 3;
  VoidCallback onMenuTap = () {};
  VoidCallback onAccountTap = () {};
  bool _isMenuVisible = false;
  String cardView = "forSale";

  void _toggleMenu(bool value) {
    setState(() {
      _isMenuVisible = value;
    });
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    Get.find<BrandController>().fetchCarMakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        toolbarHeight: 60.h,
        shadowColor: Colors.grey.shade300,

        // elevation: 3,
        elevation: .4,
        leading: // Menu Button
            GestureDetector(onTap: () {
              Get.to(MainMenu());
            }, child: Icon(Icons.menu)),
        actions: [
          // Account Button with Notification Counter (smaller)
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(MyAccount());
                },
                child: Image.asset(
                  'assets/images/ic_personal_account.png',
                  width: 20,
                  height: 20,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 7,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    constraints:
                        const BoxConstraints(minWidth: 14, minHeight: 14),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notificationCount > 99
                          ? '99+'
                          : notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],

        title: SizedBox(
          height: 140,
          width: 140,
          child: Image.asset(
            'assets/images/ic_top_logo_colored.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isMenuVisible) {
                _toggleMenu(false);
              }
            },
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    adContainer(),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;
                        final crossAxisCount = screenWidth >= 600 ? 3 : 2;
                        final horizontalPadding =
                            screenWidth * 0.02 + 6; // responsive
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child:
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2,
                            children: [
                              HomeServiceCard(
                                onTap: () {
                                  _toggleMenu(true);
                                  setState(() {
                                    cardView = "forSale";
                                  });
                                },
                                title: 'Cars For Sale',
                                imageAsset:
                                    'assets/images/ic_cars_for_sale.png',
                                large: true,
                              ),
                              HomeServiceCard(
                                onTap: () {
                                  _toggleMenu(true);
                                  setState(() {
                                    cardView = "forRent";
                                  });
                                },
                                title: 'Cars For Rent',
                                imageAsset:
                                    'assets/images/ic_cars_for_rent.png',
                                large: true,
                              ),
                              HomeServiceCard(
                                onTap: () => Get.to(CarsShowRoom(carCare: true,title: "Car Care",)),
                                title: 'Car Care',
                                imageAsset: 'assets/images/ic_car_care.png',
                                large: true,
                              ),
                              HomeServiceCard(
                                onTap: () => _toggleMenu(true),
                                title: 'Garages',
                                imageAsset: 'assets/images/ic_garages.png',
                                large: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    adContainer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width *
                            0.46, // matches card height
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: HomeServiceCard(
                                  title: 'Bikes',
                                  imageAsset: 'assets/images/ic_bikes.png',
                                  large: false,
                                ),
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: HomeServiceCard(
                                  title: 'Caravans',
                                  imageAsset: 'assets/images/ic_caravans.png',
                                  large: false,
                                ),
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: HomeServiceCard(
                                  title: 'Plates',
                                  imageAsset: 'assets/images/ic_plates.png',
                                  large: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ])),
            ),
          ),
          // Slide-up menu
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: _isMenuVisible ? 0 : -400, // Slide from bottom
           // height: 320,
            child: GestureDetector(
              onTap: () {}, // prevent tap on menu from closing it
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main menu container
                  Container(
                    padding: EdgeInsets.only(top: 35.h, left: 12, right: 12,),
                    decoration: BoxDecoration(
                      color: AppColors.star,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: sildeUpGridView()
                  ),

                  // Arrow tab at top center
                  Positioned(
                    top: -15,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.star,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(

        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Get.offAll(HomeScreen());
              break;
            case 1:
              //Get.offAll(OffersScreen());
              print("object");
              break;
            case 2:
              Get.offAll(SellCarScreen());

              break;

            case 3:
              Get.offAll(FavouriteScreen());
              break;
            case 4:
              Get.offAll(ContactUsScreen());
              break;
          }
        },
        onAddPressed: () {
          // TODO: Handle Add button tap
          Get.to(SellCarScreen());
        },
      ),
    );

    // bottomNavigationBar: CustomBottomNavBar(
    //   selectedIndex: _selectedIndex,
    //   onTabSelected: (index) {
    //     setState(() {
    //       _selectedIndex = index;
    //     });
    //   },
    //   onAddPressed: () {
    //     // TODO: Handle Add button tap
    //   },
    // ),
    //);
  }
  sildeUpGridView(){

     switch (cardView) {
      case 'forSale':
        {
        return  GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 77.h,),
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 1,
            crossAxisSpacing: 3,
            childAspectRatio: 1.3,
            children: [
              HomeServiceCard(
                onTap: () {
                  Get.to(AllCars());
                },
                title: 'All Cars',
                imageAsset: 'assets/images/ic_all_cars.png',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  Get.find<BrandController>().getCars(make_id: 0, makeName: "Qars Spin Showrooms",sourceKind: "Qars spin");
                  Get.to(CarsBrandList(brandName: "Qars Spin \n Showroom",));
                },
                title: 'Qars Spin Showrooms',
                imageAsset: 'assets/images/logo_the_q.png',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  Get.to(CarsShowRoom(title: "Rental Showrooms For Sale",));
                },
                title: 'Cars Showrooms',
                imageAsset: 'assets/images/ic_cars_for_sale.png',
                large: false,
              ),
              HomeServiceCard(
                title: 'Personal Cars',
                onTap: () {
                  Get.find<BrandController>().getCars(make_id: 0, makeName: "Personal Cars",sourceKind: "Individual");

                  Get.to(CarsBrandList(brandName: "Personal Cars",));
                },
                imageAsset: 'assets/images/ic_personal_cars.png',
                large: false,
              ),
            ],
          );
          print("object");
          break;
        }


      case 'forRent':
        {
         return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 77.h,),
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 1,
            crossAxisSpacing: 3,
            childAspectRatio: 1.3,
            children: [
              HomeServiceCard(
                onTap: () {
                  Get.find<RentalCarsController>().fetchRentalCars();
                  Get.to(AllRentalCars());
                },
                title: 'All Rental Cars',
                imageAsset: 'assets/images/ic_cars_for_rent.png',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  Get.to(CarsShowRoom(title: "Rental Showrooms",));
                },
                title: 'Rental Showrooms',
                imageAsset: 'assets/images/ic_rental_showrooms.png',
                large: false,
              ),

            ],
          );
          break;
        }
    }
  }
}
