import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:le_qvt/pages/ProfilePage/ProfilePage.dart';
import 'package:le_qvt/pages/SettingPage/SettingsPage.dart';
import 'package:le_qvt/pages/homepage/home_page.dart';
import 'package:le_qvt/pages/questionpage/question_page.dart';
import 'package:le_qvt/pages/statspage/stats_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
    QuestionPage(),
    StatsPage(
      ratings: [2, 5, 6],
    ),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home),
          Icon(Icons.person),
          Icon(Icons.quiz),
          Icon(Icons.stacked_bar_chart_sharp),
          Icon(Icons.settings),
        ],
      ),
    );
  }
}
