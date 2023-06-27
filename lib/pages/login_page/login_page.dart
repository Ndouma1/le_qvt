import 'package:flutter/material.dart';
//import 'package:le_qvt/pages/adminPage/admin_page.dart';
import 'package:le_qvt/pages/bottomNavigation/bottom_navigation.dart';
//import 'package:le_qvt/pages/homepage/home_page.dart';
import 'package:le_qvt/pages/homepage/home_page_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Employé';

  String? userId;
  String? name;
  String? role;
  String? profileIcon;

  void _login() async {
    String email = _nameController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Récupérer les informations de l'utilisateur à partir de Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Mettre à jour les champs avec les informations récupérées
          setState(() {
            userId = user.uid;
            name = userData['Nom'];
            role = userData['role'];
            profileIcon = userData['profileIcon'];
          });

          if (role == 'Employé') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigation()),
            );
          } else if (role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePageAdmin()),
            );
          }
        }
      }
    } catch (e) {
      // Gérer les erreurs d'authentification ici
      print('Erreur de connexion : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Identifiant de connexion (adresse email)',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              items: <String>['Employé', 'admin']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Rôle',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Connexion'),
            ),
          ],
        ),
      ),
    );
  }
}
