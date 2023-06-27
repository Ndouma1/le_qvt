import 'package:flutter/material.dart';

class ParametreAdminPage extends StatelessWidget {
  const ParametreAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paramètres de l\'administrateur',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Personnalisez les paramètres de votre espace administrateur ici.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Exemple de contenu de paramètres :',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Modifier le profil'),
              onTap: () {
                // Handle profile editing
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Modifier le mot de passe'),
              onTap: () {
                // Handle password editing
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Changer la langue'),
              onTap: () {
                // Handle language selection
              },
            ),
            // Add more settings options as needed
          ],
        ),
      ),
    );
  }
}
