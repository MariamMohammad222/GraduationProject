import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectgraduation/constants/colorview.dart';
import 'package:projectgraduation/screens/fillrelativesInformation.dart';
import 'package:projectgraduation/screens/mainScreen.dart';
import 'package:projectgraduation/widgets/camerawidget.dart';
import 'package:projectgraduation/widgets/countrywidget.dart';
import 'package:projectgraduation/widgets/nextbutton.dart';

class UserFormScreen extends StatefulWidget {
  final String id = 'userformscreen';
  final String userId;

  const UserFormScreen({super.key, required this.userId});
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  String? selectedCountry;
  int selectedAge = 18;
  String? selectedGender;
  String otherDisease = "";
  List<String> chronicDiseases = [];
  final TextEditingController phoneController = TextEditingController();

  final List<int> ageOptions = List.generate(80, (index) => index + 18);
  final List<String> diseases = [
    "Diabetes",
    "High Blood Pressure",
    "Chronic neurological diseases (e.g epilepsy)",
    "Chronic Respiratory Diseases",
    "Asthma",
    "Other"
  ];

  void _saveUserData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(widget.userId).update({
      'country': selectedCountry,
      'age': selectedAge,
      'gender': selectedGender,
      'phone': phoneController.text, // إضافة رقم الهاتف
      'chronicDiseases': chronicDiseases,
    }).then((_) {
      print("User Data Saved!");
    }).catchError((error) {
      print("Failed to save user: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tcare',
          style: TextStyle(
            fontSize: 22,
            fontFamily: "TimesNewRoman",
            fontWeight: FontWeight.bold,
            color: AppUI.colorSeconder,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: CameraWidget(userId: widget.userId)),
              SizedBox(height: 20),

              // رقم الهاتف
              Text("Number",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),

              SizedBox(height: 15),

              // اختيار الدولة
              Text("Country",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              SizedBox(height: 8),
              InkWell(
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
              ),

              SizedBox(height: 15),

              // اختيار العمر
              Text("Age",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedAge,
                items: ageOptions
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedAge = value!),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),

              SizedBox(height: 18),

              // اختيار الجنس
              Text("Gender",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      child: TextButton(
                        onPressed: () => setState(() => selectedGender = "Male"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            selectedGender == "Male"
                                ? AppUI.colorPrimary
                                : Colors.grey[200],
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            selectedGender == "Male"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        child: Text("Male"),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 55,
                      child: TextButton(
                        onPressed: () => setState(() => selectedGender = "Female"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            selectedGender == "Female"
                                ? AppUI.colorPrimary
                                : Colors.grey[200],
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            selectedGender == "Female"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        child: Text("Female"),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              // اختيار الأمراض المزمنة
              Text("Select Your Chronic Diseases",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppUI.fontarial)),
              Column(
                children: diseases.map((disease) {
                  return CheckboxListTile(
                    title: Text(disease),
                    value: chronicDiseases.contains(disease),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          chronicDiseases.add(disease);
                        } else {
                          chronicDiseases.remove(disease);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // إدخال مرض آخر
              if (chronicDiseases.contains("Other"))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Please specify",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        otherDisease = value;
                        if (value.isNotEmpty) {
                          if (!chronicDiseases.contains(value)) {
                            chronicDiseases.add(value);
                          }
                        } else {
                          chronicDiseases.removeWhere((disease) =>
                              disease != "Other" && disease == otherDisease);
                        }
                      });
                    },
                  ),
                ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  _saveUserData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return RelativesScreen(userId: widget.userId);
                    }),
                  );
                },
                child: nextwidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
