import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentService {
  // Test API Key
  static const String apiKey =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

  /// Initialize MyFatoorah SDK
  static void initialize() {
    try {
      MFSDK.init(apiKey, MFCountry.KUWAIT, MFEnvironment.TEST);
      log('MyFatoorah SDK initialized successfully');
    } catch (e) {
      log('Error initializing MyFatoorah SDK: $e');
    }
  }

  /// Get available payment methods
  static Future<List<MFPaymentMethod>> getPaymentMethods(double amount) async {
    try {
      final request = MFInitiatePaymentRequest(
        invoiceAmount: amount,
        currencyIso: MFCurrencyISO.KUWAIT_KWD,
      );
      final response = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);
      return response.paymentMethods ?? [];
    } catch (e) {
      log('Error fetching payment methods: $e');
      return [];
    }
  }

  /// Execute payment (Redirect or Direct)
  static Future<bool> executePaymentWithPolling(
      BuildContext context, int methodId, double amount) async {
    try {
      final request = MFExecutePaymentRequest(invoiceValue: amount)
        ..paymentMethodId = methodId;

      await MFSDK.executePayment(request, MFLanguage.ENGLISH,
              (String invoiceId) async {
            log('[EXECUTE] Invoice created: $invoiceId');

            // Wait a bit and check status
            await Future.delayed(const Duration(seconds: 3));
            final statusResponse = await getPaymentStatus(invoiceId);

            if (statusResponse != null) {
              final status = statusResponse.invoiceStatus ?? "UNKNOWN";
              log('[STATUS] Invoice $invoiceId → $status');

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      status.toUpperCase() == "PAID"
                          ? "Payment completed successfully!"
                          : "Payment status: $status",
                    ),
                  ),
                );
              }
            }
          });

      return true;
    } on MFError catch (e) {
      log('[EXECUTE][MFError] code=${e.code}, message=${e.message}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment execution error: ${e.message}")),
        );
      }
      return false;
    } catch (e) {
      log('[EXECUTE][ERROR] $e');
      return false;
    }
  }

  /// Get payment status by invoiceId
  static Future<MFGetPaymentStatusResponse?> getPaymentStatus(
      String invoiceId) async {
    try {
      final request = MFGetPaymentStatusRequest(
        key: invoiceId,
        keyType: MFKeyType.INVOICEID,
      );
      final response = await MFSDK.getPaymentStatus(request, MFLanguage.ENGLISH);
      return response;
    } catch (e) {
      log('Error getting payment status: $e');
      return null;
    }
  }
}
