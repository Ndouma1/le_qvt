import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:le_qvt/pages/login_page.dart';
import 'package:le_qvt/pages/login_page/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: LoginPage(), // Utilisation de LoginPage comme page d'accueil
    );
  }
}
