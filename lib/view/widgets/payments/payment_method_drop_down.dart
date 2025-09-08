// import 'package:flutter/material.dart';
// import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
//
// class PaymentMethodDropdown extends StatelessWidget {
//   final List<MFPaymentMethod> methods;
//   final MFPaymentMethod? selectedMethod;
//   final ValueChanged<MFPaymentMethod?> onChanged;
//
//   const PaymentMethodDropdown({
//     Key? key,
//     required this.methods,
//     required this.selectedMethod,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (methods.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return DropdownButton<MFPaymentMethod>(
//       value: selectedMethod,
//       isExpanded: true,
//       items: methods
//           .map(
//             (m) => DropdownMenuItem(
//           value: m,
//           child: Text(m.paymentMethodEn ?? "Method"),
//         ),
//       )
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
// }
