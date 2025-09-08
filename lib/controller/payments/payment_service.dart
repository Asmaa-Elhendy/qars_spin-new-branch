// import 'package:flutter/material.dart';
// import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
//
// class PaymentService {
//   /// 🔹 رجع كل طرق الدفع المتاحة
//   static Future<List<MFPaymentMethod>> getPaymentMethods(double amount) async {
//     MFInitiatePaymentRequest request = MFInitiatePaymentRequest(
//       invoiceAmount: amount,
//       currencyIso: MFCurrencyISO.KUWAIT_KWD,
//     );
//
//     final response = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);
//     return response.paymentMethods ?? [];
//   }
//
//   /// 🔹 نفذ الدفع بالطريقة المختارة
//   static Future<void> executePayment(
//       BuildContext context, int paymentMethodId, double amount) async {
//     try {
//       MFExecutePaymentRequest request = MFExecutePaymentRequest(
//         invoiceValue: amount,
//       );
//       request.paymentMethodId = paymentMethodId;
//
//       await MFSDK.executePayment(
//         request,
//         MFLanguage.ENGLISH,
//             (invoiceId) {
//           // 🔹 طباعة الـ Invoice ID
//           debugPrint("Invoice ID: $invoiceId");
//
//           // 🔹 عرض SnackBar مباشرة داخل الـ callback
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("✅ Payment Successful: $invoiceId")),
//             );
//           }
//         },
//       ).then((response) {
//         // ممكن تستخدم هنا لمتابعة حالة الفاتورة بعد التنفيذ
//         debugPrint("Invoice Status: ${response.invoiceStatus}");
//         if (context.mounted) {
//           if (response.invoiceStatus == "Paid") {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("✅ Payment Successful")),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("❌ Payment Failed: ${response.invoiceStatus}")),
//             );
//           }
//         }
//       }).catchError((error) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("⚠ Error: ${error.message}")),
//           );
//         }
//         debugPrint("Payment Error: $error");
//       });
//     } catch (e) {
//       debugPrint("Exception in payment: $e");
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentService {
  static const String apiKey =     "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL"
  ;
  /// 🔹 استرجاع طرق الدفع
  static Future<List<MFPaymentMethod>> getPaymentMethods(double amount) async {
    MFInitiatePaymentRequest request = MFInitiatePaymentRequest(
      invoiceAmount: amount,
      currencyIso: MFCurrencyISO.KUWAIT_KWD,
    );

    final response = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);
    return response.paymentMethods ?? [];
  }

  /// 🔹 تنفيذ الدفع وعرض حالة الفاتورة مباشرة حتى لو Pending
  // static Future<void> executePayment(
  //     BuildContext context, int paymentMethodId, double amount) async
  // {
  //   try {
  //     MFExecutePaymentRequest request = MFExecutePaymentRequest(
  //       invoiceValue: amount,
  //     );
  //     request.paymentMethodId = paymentMethodId;
  //
  //     await MFSDK.executePayment(request, MFLanguage.ENGLISH, (invoiceId) async {
  //       debugPrint("Invoice ID: $invoiceId");
  //
  //       try {
  //         MFGetPaymentStatusRequest statusRequest = MFGetPaymentStatusRequest(
  //           key: invoiceId,
  //           keyType: MFKeyType.INVOICEID,
  //         );
  //
  //         final statusResponse = await MFSDK.getPaymentStatus(
  //           statusRequest,
  //           MFLanguage.ENGLISH,
  //         );
  //
  //         debugPrint("Invoice Status: ${statusResponse.invoiceStatus}");
  //
  //         if (context.mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 "Invoice ID: $invoiceId | Status: ${statusResponse.invoiceStatus}",
  //               ),
  //               duration: const Duration(seconds: 5),
  //             ),
  //           );
  //         }
  //       } catch (e) {
  //         debugPrint("Error fetching invoice status: $e");
  //         if (context.mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("⚠ Error checking payment status")),
  //           );
  //         }
  //       }
  //     }).catchError((error) {
  //       debugPrint("Payment Error: $error");
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("⚠ Payment Error: ${error.message}")),
  //         );
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("Exception in payment: $e");
  //   }
  // }
  static Future<void> executePaymentWithPolling(
      BuildContext context, int paymentMethodId, double amount) async {
    try {
      MFExecutePaymentRequest request = MFExecutePaymentRequest(
        invoiceValue: amount,
      );
      request.paymentMethodId = paymentMethodId;

      await MFSDK.executePayment(request, MFLanguage.ENGLISH, (invoiceId) async {
        debugPrint("Invoice ID: $invoiceId");

        if (!context.mounted) return;

        // SnackBar فوري مع حالة مؤقتة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invoice created: $invoiceId | Status: Pending..."),
            duration: const Duration(seconds: 5),
          ),
        );

        // 🔹 Polling للتحقق من حالة الفاتورة كل 5 ثواني حتى تتحول من Pending
        bool done = false;
        while (!done && context.mounted) {
          try {
            final statusResponse = await MFSDK.getPaymentStatus(
              MFGetPaymentStatusRequest(
                key: invoiceId,
                keyType: MFKeyType.INVOICEID,
              ),
              MFLanguage.ENGLISH,
            );

            debugPrint("Invoice Status: ${statusResponse.invoiceStatus}");

            if (statusResponse.invoiceStatus != "Pending") {
              done = true;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    statusResponse.invoiceStatus == "Paid"
                        ? "✅ Payment Successful: $invoiceId"
                        : "❌ Payment Failed: ${statusResponse.invoiceStatus}",
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            } else {
              await Future.delayed(const Duration(seconds: 5));
            }
          } catch (e) {
            debugPrint("Error checking invoice status: $e");
            done = true;
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⚠ Error checking payment status")),
              );
            }
          }
        }
      }).catchError((error) {
        debugPrint("Payment Error: $error");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("⚠ Payment Error: ${error.message}")),
          );
        }
      });
    } catch (e) {
      debugPrint("Exception in payment: $e");
    }
  }

}
