import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:qarsspin/controller/const/colors.dart';
import '../../../controller/payments/payment_service.dart';

class PaymentMethodDialog extends StatefulWidget {
  final double amount;

  const PaymentMethodDialog({Key? key, required this.amount}) : super(key: key);

  static Future<bool?> show({required BuildContext context, required double amount}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentMethodDialog(amount: amount),
    );
  }

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  List<MFPaymentMethod> methods = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  Future<void> _loadMethods() async {
    try {
      methods = await PaymentService.getPaymentMethods(widget.amount);
    } catch (e) {
      debugPrint("Error loading payment methods: $e");
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.toastBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        height: 700.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose Payment Method",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            16.verticalSpace,
            if (loading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary,))
            else if (methods.isEmpty)
              Text(
                "No payment methods available",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: methods.length,
                  separatorBuilder: (_, __) => 12.verticalSpace,
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    return InkWell(
                      onTap: () async {
                        // Keep dialog open while processing, then pop with result
                        final success = await PaymentService.executePaymentWithPolling(
                          context,
                          method.paymentMethodId!,
                          widget.amount,
                        );
                        if (mounted) Navigator.pop(context, success);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.logoGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (method.imageUrl != null)
                              Image.network(
                                method.imageUrl!,
                                width: 40.w,
                                height: 40.w,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.payment),
                              ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                method.paymentMethodEn ?? "Unknown",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cancelButton(() => Navigator.pop(context, false), "Cancel"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cancelButton(VoidCallback ontap, String title) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 95.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.logoGray,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}
