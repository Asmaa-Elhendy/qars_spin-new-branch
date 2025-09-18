import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentService {
  // Test API Key for MyFatoorah
  static const String apiKey = "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  /*
  static const String apiKey = "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

  */
  // Initialize MyFatoorah SDK
  static void initialize() {
    try {
      MFSDK.init(
        apiKey,
        MFCountry.KUWAIT,
        MFEnvironment.TEST,
      );
      log('MyFatoorah SDK initialized successfully');
    } catch (e) {
      log('Error initializing MyFatoorah SDK: $e');
    }
  }
  /// استرجاع طرق الدفع
  static Future<List<MFPaymentMethod>> getPaymentMethods(double amount) async {
    try {
      log('Getting payment methods for amount: $amount');
      final request = MFInitiatePaymentRequest(
        invoiceAmount: amount,
        currencyIso: MFCurrencyISO.KUWAIT_KWD,
      );

      final response = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);
      final count = response.paymentMethods?.length ?? 0;
      log('Successfully retrieved $count payment methods');
      return response.paymentMethods ?? [];
    } on MFError catch (e) {
      // MyFatoorah specific error
      log('MyFatoorah Error: code: ${e.code}, message: ${e.message}');
      return [];
    } catch (e, st) {
      // General error
      log('Error getting payment methods: ${e.toString()}');
      log('Stack trace: $st');
      return [];
    }
  }

  static Future<bool> executePaymentWithPolling(
      BuildContext context, int paymentMethodId, double amount) async {
    try {
      MFExecutePaymentRequest request = MFExecutePaymentRequest(
        invoiceValue: amount,
      );
      request.paymentMethodId = paymentMethodId;

      bool success = false;

      await MFSDK.executePayment(request, MFLanguage.ENGLISH, (invoiceId) async {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invoice created: $invoiceId | Status: Pending..."),
            duration: const Duration(seconds: 5),
          ),
        );

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

            final status = statusResponse.invoiceStatus;

            if (status != "Pending") {
              done = true;
              success = status == "Paid";
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? " Payment Successful: $invoiceId"
                        : " Payment Failed: $status",
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            } else {
              await Future.delayed(const Duration(seconds: 5));
            }
          } catch (e) {
            done = true;
            success = false;
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(" Error checking payment status")),
              );
            }
          }
        }
      }).catchError((error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" Payment Error: ${error.toString()}")),
          );
        }
      });

      return success;
    } catch (e) {
      debugPrint('executePaymentWithPolling error: $e');
      return false;
    }
  }

}
