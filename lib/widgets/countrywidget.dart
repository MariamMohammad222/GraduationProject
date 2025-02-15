import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class country extends StatefulWidget {
  const country({super.key});

  @override
  State<country> createState() => _countryState();
}

class _countryState extends State<country> {
  String? selectedCountry = 'Egypt';
  @override
  Widget build(BuildContext context) {
    return  InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name;
                      });
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCountry ?? "Select Country",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              );
  }
}