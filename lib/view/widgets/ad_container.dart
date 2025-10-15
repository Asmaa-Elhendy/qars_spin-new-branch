import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/banner_service.dart';
import '../../model/banner_model.dart';

class AdContainer extends StatefulWidget {
  final bool bigAdHome;
  final String targetPage; // e.g., 'Home Page', 'Cars For Sale - List Page'
  
  const AdContainer({
    Key? key,
    this.bigAdHome = false,
    this.targetPage = 'Global',
  }) : super(key: key);

  @override
  _AdContainerState createState() => _AdContainerState();
}

class _AdContainerState extends State<AdContainer> {
  BannerModel? _banner;
  bool _isLoading = true;
  final BannerService _bannerService = BannerService();

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    if (!mounted) return;
    
    try {
      print('🔄 Loading banners for ${widget.targetPage}...');
      setState(() => _isLoading = true);
      
      final banners = await _bannerService.getActiveBanners();
      
      if (!mounted) return;
      
      if (banners.isEmpty) {
        print('⚠️ No banners received from API');
        setState(() => _isLoading = false);
        return;
      }

      final bannerType = widget.bigAdHome ? 'Big' : 'Small';
      final banner = _bannerService.getBannerByPriority(
        banners,
        widget.targetPage,
        bannerType,
      );
      
      if (banner != null) {
        print('✅ Displaying banner: ${banner.bannerId} - ${banner.bannerType}');
      } else {
        print('ℹ️ No matching banner found for current criteria');
      }

      if (mounted) {
        setState(() {
          _banner = banner;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading banner: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildErrorWidget() {
    return GestureDetector(
      onTap: _loadBanner,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        height: widget.bigAdHome ? 170.h : 115.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Default image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                'assets/images/new_svg/Big_ads.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 40.w, color: Colors.grey[400]),
                ),
              ),
            ),
            // Subtle retry indicator at bottom right
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.refresh,
                  size: 16.w,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildPlaceholder();
    }

    if (_banner == null) {
      return _buildErrorWidget();
    }

    return GestureDetector(
      onTap: _banner?.targetUrlPl?.isNotEmpty == true 
          ? () => _launchUrl(_banner!.targetUrlPl!)
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        height: widget.bigAdHome ? 170.h : 115.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: _banner?.imageUrlPl?.isNotEmpty == true
              ? Image.network(
                  _banner!.imageUrlPl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ Error loading banner image: $error');
                    return _buildErrorWidget();
                  },
                )
              : _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      height: widget.bigAdHome ? 170.h : 115.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.asset(
          'assets/images/new_svg/Big_ads.png',
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40.w,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}