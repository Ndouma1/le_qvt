import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:le_qvt/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 193, 176, 176),
        appBar: AppBar(
          centerTitle: true,
          title: Text(''),
          flexibleSpace: Center(
            child: Image.asset(
              'assets/images/vintage-g11af0ca45_1280.png',
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 126, 126, 126),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ));
  }
}
