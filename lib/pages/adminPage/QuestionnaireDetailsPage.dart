import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionnaireDetailsPage extends StatelessWidget {
  final String questionnaireId;

  const QuestionnaireDetailsPage({required this.questionnaireId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du questionnaire'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Questionnaires')
            .doc(questionnaireId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Une erreur s\'est produite: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Le questionnaire n\'existe pas.'));
          }

          final questionnaireData =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (questionnaireData == null) {
            return Center(
                child: Text('Les données du questionnaire sont vides.'));
          }

          // Récupérez les champs spécifiques du questionnaire
          final String? titre = questionnaireData['titre'] as String?;
          final String? description =
              questionnaireData['description'] as String?;
          final String? dateLimite =
              questionnaireData['dateLimiteReponse'] as String?;

          final List<dynamic>? groupesCibles =
              questionnaireData['groupesCibles'] as List<dynamic>?;

          // Affichez les détails du questionnaire
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Titre: ${titre ?? ''}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Text('Description: ${description ?? ''}'),
                SizedBox(height: 16),
                Text('Date limite de réponse: ${dateLimite ?? ''}'),
                SizedBox(height: 16),
                Text('Groupes cibles: ${groupesCibles?.join(', ') ?? ''}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
