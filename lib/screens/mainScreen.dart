import 'package:flutter/material.dart';
import 'package:projectgraduation/screens/homePageScreen.dart';
import 'package:projectgraduation/screens/notificationPage.dart';
import 'package:projectgraduation/screens/profilePage.dart';
import 'package:projectgraduation/screens/settingpage.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  final String id='main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    NotificationsPage(),
     ProfilePage() ,
     SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class AnimatedBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  AnimatedBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.notifications_rounded,
    Icons.person_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
          (index) => GestureDetector(
            onTap: () => onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: selectedIndex == index ? 1.2 : 1.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: selectedIndex == index ? 1.0 : 0.5,
                    child: Icon(
                      _icons[index],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// صفحات التجربة







