import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:le_qvt/pages/QuestionPage/question_page.dart';

import '../QuestionPage/question_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!userSnapshot.hasData) {
          return Text('Utilisateur non connecté');
        }

        User? user = userSnapshot.data;
        String userId = user!.uid;

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Erreur de chargement des données');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (userData == null) {
                return Text('Aucune donnée utilisateur trouvée');
              }

              String userName = userData['Nom'];

              return Scaffold(
                appBar: AppBar(
                  title: Text('Bonjour, $userName'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QuestionPage()),
                            );
                          },
                          child: Center(
                            child: Text(
                              'Questionnaire du jour',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return CircularProgressIndicator();
          },
        );
      },
    );
  }
}
