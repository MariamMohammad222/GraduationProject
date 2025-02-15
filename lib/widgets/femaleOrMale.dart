import 'package:flutter/material.dart';
import 'package:projectgraduation/constants/colorview.dart';

class FemaleOrmale extends StatefulWidget {
   FemaleOrmale({super.key});

  @override
  State<FemaleOrmale> createState() => _FemaleOrmaleState();
}

class _FemaleOrmaleState extends State<FemaleOrmale> {
 String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return  Row(
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
              );
  }
}