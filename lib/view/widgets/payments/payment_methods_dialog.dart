import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:qarsspin/controller/const/colors.dart';
import '../../../controller/payments/payment_controller.dart';
import '../../../controller/payments/payment_service.dart';
import '../../../l10n/app_localization.dart';
import '../../../model/payment/payment_method_model.dart';

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
  String? errorMessage;

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
      errorMessage = "Failed to load payment methods.";
    }
    if (mounted) setState(() => loading = false);
  }

  void _startPayment(MFPaymentMethod method,BuildContext context) async {
    final lc = AppLocalizations.of(context)!;

    setState(() {
      errorMessage = null;
      loading = true;
    });

    try {
      final success = await PaymentService.executePaymentWithPolling(
        context,
        method.paymentMethodId!, // استخدمي الـ ID وليس الكائن كله
        widget.amount,
      );
      if (method.isDirectPayment == true) {
        if (mounted) Navigator.pop(context, success);
      } else {
        // Redirect: فقط نعلم المستخدم
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(lc.redirecting_payment)),
          );
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "${lc.payment_failed}: ${e.toString()}";
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lc = AppLocalizations.of(context)!;
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
             lc.choose_payment_method,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            16.verticalSpace,
            if (loading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary))
            else if (methods.isEmpty)
              Text(
                lc.no_payment_methods_available,
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
                      onTap: () => _startPayment(method,context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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
                                errorBuilder: (_, __, ___) => const Icon(Icons.payment),
                              ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                method.paymentMethodEn ?? lc.unknown,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (errorMessage != null) ...[
              12.verticalSpace,
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ],
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cancelButton(() => Navigator.pop(context, false), lc.btn_Cancel),
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


// Update the NewPaymentMethodsDialog class in payment_methods_dialog.dart
// Update the NewPaymentMethodsDialog class to filter by supported currencies
// Add this at the top of the file


class NewPaymentMethodsDialog extends StatefulWidget {
  final List<dynamic> paymentMethods;
  final double amount;
  final bool isArabic;

  const NewPaymentMethodsDialog({
    Key? key,
    required this.paymentMethods,
    required this.amount,
    this.isArabic = true,
  }) : super(key: key);

  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> paymentMethods,
    required double amount,
    bool isArabic = true,
  }) async {
    final paymentController = Get.find<PaymentController>();
    final supportedCurrencies = paymentController.currencies
        .map((currency) => currency.toUpperCase())
        .toList();

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => NewPaymentMethodsDialog(
        paymentMethods: paymentMethods,
        amount: amount,
        isArabic: isArabic,
      ),
    );
  }

  @override
  State<NewPaymentMethodsDialog> createState() => _NewPaymentMethodsDialogState();
}

class _NewPaymentMethodsDialogState extends State<NewPaymentMethodsDialog> {
  late List<dynamic> filteredPaymentMethods;
  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _filterPaymentMethods();
  }

  void _filterPaymentMethods() {
    final paymentController = Get.find<PaymentController>();
    final supportedCurrencies = paymentController.currencies
        .map((c) => c.toUpperCase())
        .toList();

    print('Supported Currencies: $supportedCurrencies');
    print('All Payment Methods: ${widget.paymentMethods}');

    filteredPaymentMethods = widget.paymentMethods.where((method) {
      final currencyIso = method['PaymentCurrencyIso']?.toString().toUpperCase();
      final isSupported = currencyIso != null && supportedCurrencies.contains(currencyIso);
      print('Method: ${method['PaymentMethodEn']} - Currency: $currencyIso - Supported: $isSupported');
      return isSupported;
    }).toList();

    log('Filtered Payment Methods: ${filteredPaymentMethods.length}');
  }

  void _handlePaymentMethodTap(Map<String, dynamic> method) {
    if (loading) return;

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      Navigator.pop(context, {
        'paymentMethod': method,
        'amount': widget.amount,
      });
    } catch (e) {
      setState(() {
        errorMessage = widget.isArabic
            ? 'فشل في تحديد طريقة الدفع'
            : 'Failed to select payment method';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lc = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.toastBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
      //  height: 600.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.isArabic ? 'اختر طريقة الدفع' : 'Choose Payment Method',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            16.verticalSpace,

            if (loading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary))
            else if (filteredPaymentMethods.isEmpty)
              Text(
                widget.isArabic ? 'لا توجد طرق دفع متاحة' : 'No payment methods available',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filteredPaymentMethods.length,
                  separatorBuilder: (_, __) => 12.verticalSpace,
                  itemBuilder: (context, index) {
                    final method = filteredPaymentMethods[index] as Map<String, dynamic>;
                    final methodName = widget.isArabic
                        ? (method['PaymentMethodAr'] ?? method['PaymentMethodEn'] ?? '')
                        : (method['PaymentMethodEn'] ?? method['PaymentMethodAr'] ?? '');

                    return InkWell(
                      onTap: () => _handlePaymentMethodTap(method),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.logoGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (method['ImageUrl'] != null)
                              Image.network(
                                method['ImageUrl']!,
                                width: 40.w,
                                height: 40.w,
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.payment, size: 40.w, color: Colors.white),
                              ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                methodName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (errorMessage != null) ...[
              12.verticalSpace,
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ],

            16.verticalSpace,
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 95.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.logoGray,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            widget.isArabic ? 'إلغاء' : 'Cancel',
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