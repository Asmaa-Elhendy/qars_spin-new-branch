import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import '../../controller/brand_controller.dart';
import '../../controller/const/colors.dart';
import '../../controller/rental_cars_controller.dart';
import '../widgets/ad_container.dart';
import '../widgets/main_card.dart';
import '../widgets/navigation_bar.dart';
import 'ads/create_ad_options_screen.dart';
import 'ads/create_new_ad.dart';
import 'auth/my_account.dart';
import 'cars_for_rent/all_rental_cars.dart';
import 'cars_for_sale/all_cars.dart';
import 'cars_for_sale/cars_brand_list.dart';
import 'cars_for_sale/showrooms.dart';
import 'favourites/favourite_screen.dart';
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
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow( //update asmaa
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        leading: // Menu Button
        GestureDetector(onTap: () {
          Get.to(MainMenu());
        }, child: Icon(Icons.menu)),
        actions: [
          // Account Button with Notification Counter (smaller)

          GestureDetector(
            onTap: () {
              Get.to(MyAccount());
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding:  EdgeInsets.only(right: 15.w),
                  child: Image.asset(
                    'assets/images/ic_personal_account.png',
                    width: 20.w, //update asmaa
                    height: 20.h,
                  ),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 25.w,//update asmaa
                    top: 15.h,
                    child: Container(height: 18.h,
                      constraints:
                      const BoxConstraints(minWidth: 14, minHeight: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffEC6D64),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          notificationCount > 99
                              ? '99+'
                              : notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            //    fontWeight: FontWeight.bold, //update asmaa
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
                        SizedBox(height:10.h),
                        adContainer(bigAdHome: true,),
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
                                childAspectRatio: 1.42, //instead 1.2 update asmaa
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
                                    'assets/images/new_svg/home1.svg',
                                    large: true,fromHome: 'true',
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
                                    'assets/images/new_svg/home2.svg',
                                    large: true,fromHome: 'true',
                                  ),
                                  HomeServiceCard(
                                    onTap: () {
                                      Get.find<ShowRoomsController>().fetchShowrooms(partnerKind: "Car Care Shop");
                                      Get.to(CarsShowRoom(carCare: true,title: "Car Care",rentRoom: false,));
                                    },
                                    title: 'Car Care',
                                    imageAsset: 'assets/images/new_svg/home3.svg',
                                    large: true,fromHome: 'true',
                                  ),
                                  HomeServiceCard(
                                    onTap: () => _toggleMenu(true),
                                    title: 'Garages',
                                    imageAsset: 'assets/images/new_svg/home4.svg',
                                    large: true,
                                    fromHome: 'true',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        adContainer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 1.0),
                          child: SizedBox(height: 140.h,   //update asmaa
                            child: SingleChildScrollView(padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 125.w, //update asmaa
                                    child: HomeServiceCard(
                                      title: 'Bikes',
                                      imageAsset: 'assets/images/new_svg/bikes.svg',
                                      large: false,fromHome: 'true',fromHomeSmall: true,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  SizedBox(
                                    width: 125.w, //update asmaa
                                    child: HomeServiceCard(
                                      title: 'Caravans',
                                      imageAsset: 'assets/images/new_svg/caravans.svg',
                                      large: false,fromHome: 'true',fromHomeSmall: true,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  SizedBox(
                                    width: 125.w, //update asmaa
                                    child: HomeServiceCard(
                                      title: 'Plates',
                                      imageAsset: 'assets/images/new_svg/plates.svg',
                                      large: false,fromHome: 'true',fromHomeSmall: true,
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
                        color: AppColors.primary,
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
                        child: InkWell( //update asmaa
                          onTap: (){
                            setState(() {
                              _isMenuVisible=false;
                            });
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,size: 50.h,
                          ),
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

              break;
            case 2:
              Get.offAll(CreateNewAdOptions());

              break;

            case 3:
              Get.find<BrandController>().getFavList();
              Get.offAll(FavouriteScreen());
              break;
            case 4:
              Get.offAll(ContactUsScreen());
              break;
          }
        },
        onAddPressed: () {
          // TODO: Handle Add button tap
          Get.to(CreateNewAdOptions());
        },
      ),
    );

  }
  sildeUpGridView(){

    switch (cardView) {
      case 'forSale':
        {
          return  GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 25.h,),
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 1,
            crossAxisSpacing: 30.w,
            childAspectRatio: 1.3,
            children: [
              HomeServiceCard(
                onTap: () {
                  Get.to(AllCars());
                },
                title: 'All Cars',fromHome: 'true',
                imageAsset: 'assets/images/new_svg/Group.svg',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  // qar spin show room
                  Get.find<BrandController>().getCars(make_id: 0, makeName: "Qars Spin Showrooms",sourceKind: "Qars spin");
                  Get.to(CarsBrandList(brandName: "Qars Spin \n Showroom",postKind: "",));
                },
                title: 'Qars Spin Showrooms',fromHome: 'true',
                imageAsset: 'assets/images/new_svg/Group (1).svg',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  Get.find<ShowRoomsController>().fetchShowrooms();
                  Get.to(CarsShowRoom(title: "Cars Showrooms",rentRoom: false,));
                },
                title: 'Cars Showrooms',fromHome: 'true',
                imageAsset: 'assets/images/new_svg/Group (2).svg',
                large: false,
              ),
              HomeServiceCard(fromHome: 'true',
                title: 'Personal Cars',
                onTap: () {
                  // personal cars
                  Get.find<BrandController>().getCars(make_id: 0, makeName: "Personal Cars",sourceKind: "Individual");

                  Get.to(CarsBrandList(brandName: "Personal Cars",postKind: "",));
                },
                imageAsset: 'assets/images/new_svg/Group (3).svg',
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
            padding: EdgeInsets.only(bottom: 25.h,),
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 1,
            crossAxisSpacing: 30.w,
            childAspectRatio: 1.3,

            children: [
              HomeServiceCard(
                onTap: () {
                  Get.find<RentalCarsController>().fetchRentalCars();
                  Get.to(AllRentalCars());
                },
                title: 'All Rental Cars',
                fromHome: 'true',
                imageAsset: 'assets/images/new_svg/home2.svg',
                large: false,
              ),
              HomeServiceCard(
                onTap: () {
                  Get.find<ShowRoomsController>().fetchShowrooms(partnerKind: "Rent a Car");
                  Get.to(CarsShowRoom(title: "Rental Showrooms",rentRoom: true,));
                },
                title: 'Rental Showrooms',fromHome: 'true',
                imageAsset: 'assets/images/new_svg/Group (5).svg',
                large: false,
              ),

            ],
          );
          break;
        }
    }
  }
}