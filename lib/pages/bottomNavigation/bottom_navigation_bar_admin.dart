import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:le_qvt/pages/adminPage/consulter_profile_page.dart';
import 'package:le_qvt/pages/adminPage/consulter_statistique.dart';
import 'package:le_qvt/pages/adminPage/parametre_admin_page.dart';
import 'package:le_qvt/pages/homepage/home_page_admin.dart';

class BottomNavigationBarAdmin extends StatefulWidget {
  const BottomNavigationBarAdmin({super.key});

  @override
  _BottomNavigationBarAdminState createState() =>
      _BottomNavigationBarAdminState();
}

class _BottomNavigationBarAdminState extends State<BottomNavigationBarAdmin> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Admin'),
      ),
      body: _buildSelectedTab(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: _onTabSelected,
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_selectedTabIndex) {
      case 0:
        return const HomePageAdmin();
      case 1:
        return const ConsulterProfilesPage();
      case 2:
        return const ConsulterStatistiquePage(
          questions: [],
          responses: [],
        );
      case 3:
        return const ParametreAdminPage();
      default:
        return Container();
    }
  }
}
