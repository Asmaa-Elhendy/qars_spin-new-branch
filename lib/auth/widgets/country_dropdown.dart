import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

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
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Container(

      height:height*.06 ,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        border: Border.all(color: AppColors.inputBorder, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
      child: DropdownButton<Map<String, String>>(
        value: selectedCountry,menuWidth: width*.9,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
        items: countries.map<DropdownMenuItem<Map<String, String>>>((country) {
          return DropdownMenuItem(
            value: country,
            child: Text(
              '+${country['prefix']} ${country['name']} ',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onCountrySelected(value);
          }
        },
      ),
    );
  }
}
