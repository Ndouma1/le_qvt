import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:le_qvt/pages/adminPage/QuestionnaireDetailsPage.dart';

class ListeQuestionnairesPage extends StatelessWidget {
  const ListeQuestionnairesPage({Key? key}) : super(key: key);

  void _supprimerQuestions(String questionnaireId) {
    CollectionReference questionsCollection = FirebaseFirestore.instance
        .collection('Questionnaires')
        .doc(questionnaireId)
        .collection('Questions');

    questionsCollection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    }).catchError((error) {
      print('Erreur lors de la suppression des questions: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des questionnaires'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Questionnaires').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const ListTile(
              title: Text('Aucun questionnaire trouvé'),
            );
          }
          final List<QueryDocumentSnapshot> questionnaires =
              snapshot.data!.docs;
          return ListView.builder(
            itemCount: questionnaires.length,
            itemBuilder: (context, index) {
              final questionnaire = questionnaires[index];
              final String titre = questionnaire['titre'];

              return ListTile(
                title: Text(titre),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionnaireDetailsPage(
                          questionnaireId: questionnaire.id),
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Supprimer le questionnaire'),
                        content: Text(
                            'Êtes-vous sûr de vouloir supprimer ce questionnaire ?'),
                        actions: [
                          TextButton(
                            child: Text('Annuler'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Supprimer'),
                            onPressed: () {
                              // Supprimer les questions
                              _supprimerQuestions(questionnaire.id);

                              // Supprimer le questionnaire
                              questionnaire.reference.delete();

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
