import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Questionnaire {
  final String id;
  final String titre;
  final String description;
  final Timestamp dateLimiteReponse;
  final List<String> groupesCibles;
  final List<Question> questions;

  Questionnaire({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateLimiteReponse,
    required this.groupesCibles,
    required this.questions,
  });
}

class Question {
  final String texteQuestion;

  Question({required this.texteQuestion});
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<int> ratings = [];
  int currentQuestionIndex = 0;
  List<Questionnaire> questionnaires = [];
  double? currentRating;
  bool isAnonymous = false;
  Question? currentQuestion;

  void _nextQuestion() {
    setState(() {
      if (currentRating != null) {
        ratings.add(currentRating!.round());
        currentRating = null;
      }

      if (currentQuestionIndex >= 0 &&
          currentQuestionIndex < questionnaires.length - 1) {
        currentQuestionIndex++;
        currentQuestion = questionnaires[currentQuestionIndex].questions[0];
      } else {
        if (currentQuestionIndex == questionnaires.length - 1) {
          _showConfirmationDialog();
          return;
        }
      }
    });
  }

  void _toggleAnonymous(bool value) {
    setState(() {
      isAnonymous = value;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Merci pour vos réponses !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Souhaitez-vous rester anonyme ?"),
              SwitchListTile(
                title: const Text("Rester anonyme"),
                value: isAnonymous,
                onChanged: (bool value) {
                  _toggleAnonymous(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _submitResponses() {
    // Obtenir l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String employeeId = user.uid;

      // Enregistrer les réponses dans la base de données
      for (int i = 0; i < questionnaires.length; i++) {
        String questionnaireId = questionnaires[i].id;
        int rating = ratings[i];

        // Enregistrer la réponse dans la collection "Reponses"
        FirebaseFirestore.instance.collection('Reponses').add({
          'questionnaireId': questionnaireId,
          'employeeId': employeeId,
          'rating': rating,
        });
      }

      // Afficher un message de succès ou effectuer d'autres actions nécessaires
      print('Réponses soumises avec succès');
    }
  }

  @override
  void initState() {
    super.initState();
    // Charger les questionnaires à partir de la base de données
    _loadQuestionnaires();
  }

  void _loadQuestionnaires() {
    FirebaseFirestore.instance
        .collection('Questionnaires')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<Questionnaire> loadedQuestionnaires = [];
      querySnapshot.docs.forEach((doc) {
        String id = doc.id;
        String titre = doc['titre'];
        String description = doc['description'];
        String dateLimiteReponseString = doc['dateLimiteReponse'];
        List<String> groupesCibles = List<String>.from(doc['groupesCibles']);

        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime dateLimiteReponse = dateFormat.parse(dateLimiteReponseString);
        Timestamp dateLimiteReponseTimestamp =
            Timestamp.fromDate(dateLimiteReponse);

        List<Question> loadedQuestions = [];
        FirebaseFirestore.instance
            .collection('Questionnaires')
            .doc(id)
            .collection('Questions')
            .get()
            .then((questionsSnapshot) {
          questionsSnapshot.docs.forEach((questionDoc) {
            String texteQuestion = questionDoc['texteQuestion'];
            loadedQuestions.add(Question(texteQuestion: texteQuestion));
          });

          loadedQuestionnaires.add(Questionnaire(
            id: id,
            titre: titre,
            description: description,
            dateLimiteReponse: dateLimiteReponseTimestamp,
            groupesCibles: groupesCibles,
            questions: loadedQuestions,
          ));

          setState(() {
            questionnaires = loadedQuestionnaires;
            currentQuestion = questionnaires[currentQuestionIndex].questions[0];
          });
        }).catchError((error) {
          print('Erreur lors du chargement des questions: $error');
        });
      });
    }).catchError((error) {
      print('Erreur lors du chargement des questionnaires: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionnaires.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Questionnaire'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Question currentQuestion =
        questionnaires[currentQuestionIndex].questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionnaires[currentQuestionIndex].titre,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              questionnaires[currentQuestionIndex].description,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Question ${currentQuestionIndex + 1} / ${questionnaires.length}",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              currentQuestion.texteQuestion,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            RatingBar.builder(
              initialRating: currentRating ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  currentRating = rating;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex > 0) {
                      setState(() {
                        currentQuestionIndex--;
                        currentRating = null;
                      });
                    }
                  },
                  child: const Text('Précédent'),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(currentQuestionIndex == questionnaires.length - 1
                      ? 'Terminer'
                      : 'Suivant'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuestionPage(),
  ));
}
