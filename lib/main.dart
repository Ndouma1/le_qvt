import 'package:flutter/material.dart';
import 'package:le_qvt/pages/bottomNavigation/bottom_navigation.dart';
import 'package:le_qvt/pages/homepage/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      theme: ThemeData(
          // Configuration du thème
          ),
      home:
          BottomNavigation(), // Utilisation de BottomNavigation comme page d'accueil
    );
  }
}
