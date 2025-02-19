import 'package:flutter/material.dart';
import 'package:projectgraduation/models/onboardingModel.dart';
import 'package:projectgraduation/screens/profilePage.dart';
import 'package:projectgraduation/screens/mainScreen.dart';
import 'package:projectgraduation/screens/loginScreen.dart';
import 'package:projectgraduation/constants/colorview.dart';
import 'package:projectgraduation/widgets/onboardingWidget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  List<OnboardingModel> onboard = [
    OnboardingModel(
        imagePath: 'assets/images/Group.png',
        heading: 'Integration with Smart Wristband',
        description:
            'The app integrates with a smart wristband to display essential health metrics.'),
    OnboardingModel(
        imagePath: 'assets/images/Group (1).png',
        heading: 'Vital Signs Display',
        description:
            'It shows metrics like blood pressure and heart rate.'),
    OnboardingModel(
        imagePath: 'assets/images/Group (2).png',
        heading: 'Medication Schedule Tracking',
        description:
            'The app accurately tracks the patient medication schedule.'),
    OnboardingModel(
        imagePath: 'assets/images/Group 1.png',
        heading: 'Emergency and Family Alert',
        description:
            'If the wristband detects any health risk, the app alerts emergency services and sends the patient’s location to family members when needed.'),
  ];

  void _nextPage() {
    if (currentPage < onboard.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  MainScreen()));
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                'Tcare',
                style:TextStyle(
                  fontSize: 22,
                  fontFamily: "TimesNewRoman",
                  fontWeight: FontWeight.bold,
                  color: AppUI.colorSeconder,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboard.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return onboardingWidget(model: onboard[index]);
              },
            ),
          ),
              SmoothPageIndicator(    
                       controller: _pageController,  // PageController    
                        count:  4, 
                           
                      effect:WormEffect(
                        
                        dotHeight: 10,
                        activeDotColor: AppUI.colorPrimary
                      ),  // your preferred effect    
                       onDotClicked: (index){    
                       }
                      ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _prevPage,
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppUI.colorPrimary,
                    child: Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),
                ),
                if (currentPage == onboard.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => login()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUI.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text("Start", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                else
                  IconButton(
                    onPressed: _nextPage,
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppUI.colorPrimary,
                      child: Icon(Icons.chevron_right, color: Colors.white, size: 30),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}