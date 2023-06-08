import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color _iconColor = Colors.blue;
  IconData _photoIcon = Icons.person;

  void _changeIconColor(Color? color) {
    if (color != null) {
      setState(() {
        _iconColor = color;
      });
    }
  }

  void _changePhotoIcon(IconData? icon) {
    if (icon != null) {
      setState(() {
        _photoIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 80.0,
              child: Icon(
                _photoIcon,
                size: 100.0,
                color: _iconColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Personnaliser le profil',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Couleur des icônes'),
              trailing: DropdownButton<Color>(
                value: _iconColor,
                items: <Color>[
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.yellow,
                ].map((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      color: color,
                    ),
                  );
                }).toList(),
                onChanged: _changeIconColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Icône de la photo de profil'),
              trailing: DropdownButton<IconData>(
                value: _photoIcon,
                items: <IconData>[
                  Icons.person,
                  Icons.account_circle,
                  Icons.face,
                ].map((IconData icon) {
                  return DropdownMenuItem<IconData>(
                    value: icon,
                    child: Icon(icon),
                  );
                }).toList(),
                onChanged: _changePhotoIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
