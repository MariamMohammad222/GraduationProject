import 'dart:io';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectgraduation/constants/colorview.dart';

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  String? selectedCountry = 'Egypt';
  int selectedAge = 21;
  String? selectedGender;
  List<String> chronicDiseases = [];
   File? _selectedImage;
  final List<int> ageOptions = List.generate(80, (index) => index + 18);
  final List<String> diseases = [
    "Diabetes",
    "High Blood Pressure",
    "Chronic neurological diseases (e.g epilepsy)",
    "Chronic Respiratory Diseases",
    "Asthma",
    "Other"
  ];
    final ImagePicker _picker = ImagePicker();

  // دالة اختيار الصورة
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // دالة لعرض خيارات اختيار الصورة
  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take a Picture"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
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
              // Profile Image
            Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _showImagePickerDialog,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppUI.colorSeconder,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Phone Number
              Text("Number",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 15),

              // Country Picker
              Text("Country",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
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
                      Text(selectedCountry ?? "Select Country"),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Age Dropdown
              Text("Age",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              DropdownButtonFormField<int>(
                value: selectedAge,
                items: ageOptions
                    .map((age) => DropdownMenuItem(
                        value: age, child: Text(age.toString())))
                    .toList(),
                onChanged: (value) => setState(() => selectedAge = value!),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 15),

              // Gender Selection
              Text("Gender",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppUI.fontarial,
                      fontSize: 18)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.zero),
                         // border: Border.all(color: AppUI.colorPrimary)
                          ),
                      height: 70,
                      child: TextButton(
                        onPressed: () =>
                            setState(() => selectedGender = "Male"),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => selectedGender = "Female"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedGender == "Female"
                              ? AppUI.colorPrimary
                              : Colors.grey[200],
                          foregroundColor: selectedGender == "Female"
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text("Female"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Chronic Diseases Checkboxes
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
              SizedBox(height: 20),

              // Next Button
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: AppUI.colorPrimary,
                    ),
                    child: Text("Next",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontFamily: AppUI.fontarial)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
