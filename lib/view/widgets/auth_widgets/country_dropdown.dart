import 'package:flutter/material.dart';

import '../../../controller/const/colors.dart';

class CountryDropdown extends StatelessWidget {
  final List<Map<String, String>> countries;
  final Map<String, String> selectedCountry;
  final Function(Map<String, String>) onCountrySelected;

  const CountryDropdown({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTapDown: (TapDownDetails details) async {
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

        final result = await showMenu<Map<String, String>>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy + height * .04,
            overlay.size.width - details.globalPosition.dx,
            overlay.size.height - details.globalPosition.dy,
          ),
          items: countries.map((country) {
            return PopupMenuItem<Map<String, String>>(
              value: country,
              // هنا هنخلي الخلفية بيضا
              // ونزبط العرض بنفس عرض الزرار
              child: SizedBox(
                width: width ,
                child: Text(
                  '+${country['prefix']} ${country['name']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
          color: Colors.white, // ⬅️ لون خلفية القائمة
        );

        if (result != null) {
          onCountrySelected(result);
        }
      },
      child: Container(
        height: height * .06,
        width: width * .9, // ⬅️ عرض الزرار
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.inputBorder, width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '+${selectedCountry['prefix']} ${selectedCountry['name']}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
