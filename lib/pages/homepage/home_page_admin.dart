import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:le_qvt/pages/adminPage/calander_page.dart';
import 'package:le_qvt/pages/adminPage/consulter_profile_page.dart';
import 'package:le_qvt/pages/adminPage/consulter_statistique.dart';
import 'package:le_qvt/pages/adminPage/faire_questionnaire.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
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
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildGridItem(
                  Icons.person,
                  'Consulter Profils',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConsulterProfilesPage()),
                    );
                  },
                ),
                _buildGridItem(
                  Icons.bar_chart,
                  'Voir les Statistiques',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConsulterStatistiquePage(
                                questions: [],
                                responses: [],
                              )),
                    );
                  },
                ),
                _buildGridItem(
                  Icons.assignment,
                  'Faire un Questionnaire',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FaireQuestionnaire()),
                    );
                  },
                ),
                _buildGridItem(
                  Icons.calendar_today,
                  'Voir le Calendrier',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalanderPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.blueAccent,
      items: const [
        Icon(Icons.person, size: 30),
        Icon(Icons.bar_chart, size: 30),
        Icon(Icons.assignment, size: 30),
        Icon(Icons.calendar_today, size: 30),
      ],
      onTap: _onTabSelected,
    );
  }
}
