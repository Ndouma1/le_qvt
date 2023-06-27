import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              'Paramètres généraux',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Langue'),
              trailing: DropdownButton<String>(
                value: 'fr',
                items: <String>[
                  'fr',
                  'en',
                  'es',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // Mettez à jour la langue sélectionnée
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: (newValue) {
                  // Mettez à jour l'état des notifications
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Autres paramètres',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Supprimer le compte'),
              onTap: () {
                // Afficher une boîte de dialogue de confirmation
              },
            ),
          ],
        ),
      ),
    );
  }
}
