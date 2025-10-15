import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/view/widgets/favourites/favourite_car_card.dart';
import 'package:qarsspin/view/widgets/navigation_bar.dart';
import 'package:qarsspin/view/screens/cars_for_sale/car_details.dart';
import 'package:qarsspin/view/widgets/ads/dialogs/loading_dialog.dart';

import 'ads/create_ad_options_screen.dart';
import 'favourites/favourite_screen.dart';
import 'general/contact_us.dart';
import 'home_screen.dart';



class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int _selectedIndex = 1;
  final BrandController _controller = Get.find<BrandController>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupLoadingListener();
    _loadOffers();
  }

  void _setupLoadingListener() {
    ever(_controller.isLoadingOffers, (isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = isLoading as bool;
        });
      }
    });

    // Initial check
    if (_controller.isLoadingOffers.isTrue) {
      _isLoading = true;
    }
  }

  Future<void> _loadOffers() async {
    await _controller.getMyOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          "My Offers",
          style: TextStyle(
            color: AppColors.blackColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.background(context),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.background(context),
            boxShadow: [
              BoxShadow( //update asmaa
                color: AppColors.blackColor(context).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
//k

      body: Stack(
        children: [
          // Main Content
          GetBuilder<BrandController>(
            builder: (controller) {
              if (controller.myOffersList.isEmpty) {
                return Center(
                  child: Text(
                    'No offers found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: _loadOffers,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  itemCount: controller.myOffersList.length,
                  itemBuilder: (context, index) {
                    final offer = controller.myOffersList[index];
                    return GestureDetector(
                      onTap: () {
                        controller.getCarDetails(
                          offer.postKind,
                          offer.postId.toString(),
                        );
                        Get.to(
                          () => CarDetails(
                            sourcekind: offer.sourceKind,
                            postKind: offer.postKind,
                            id: offer.postId,
                          ),
                        );
                      },
                      child: FavouriteCarCard(
                        myOffer: 'Offer',
                        title: offer.carNamePl,
                        price: offer.askingPrice,
                        location: '',
                        meilage: '${offer.mileage} KM',
                        manefactureYear: offer.manufactureYear.toString(),
                        imageUrl: offer.rectangleImageUrl,
                        onHeartTap: () {
                          // Handle remove offer if needed
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Loading Overlay
          if (_isLoading)
            Container(
              color:Colors.black.withOpacity(0.5),
              child: const Center(
                child: AppLoadingWidget(
                  title: 'Loading...\nPlease Wait...',
                ),
              ),
            ),

        ],
      )
      ,

      // Bottom Nav Bar
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
            Get.offAll(OffersScreen());

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
}
