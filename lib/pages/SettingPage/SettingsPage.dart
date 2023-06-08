import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paramètres généraux',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Langue'),
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
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: (newValue) {
                  // Mettez à jour l'état des notifications
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Autres paramètres',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Supprimer le compte'),
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
