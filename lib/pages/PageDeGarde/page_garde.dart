import 'package:flutter/material.dart';

class PageGarde extends StatelessWidget {
  const PageGarde({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Application'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenue sur la page d\'accueil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton
              },
              child: const Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}
