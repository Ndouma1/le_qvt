import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<int?> ratings = [];
  int currentQuestionIndex = 0;
  List<String> questions = [
    "Question 1 : Évaluez votre niveau de satisfaction au travail",
    "Question 2 : Évaluez votre équilibre entre vie professionnelle et personnelle",
    "Question 3 : Évaluez l'environnement de travail",
    // Ajoutez autant de questions que vous le souhaitez
  ];

  double? currentRating;
  bool isAnonymous = false;

  void _answerQuestion(double rating) {
    setState(() {
      currentRating = rating;
    });
  }

  void _nextQuestion() {
    setState(() {
      ratings.add(currentRating?.round());
      currentRating = null;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showConfirmationDialog();
      }
    });
  }

  void _toggleAnonymous() {
    setState(() {
      isAnonymous = !isAnonymous;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Merci pour vos réponses !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Souhaitez-vous rester anonyme ?"),
              ListTile(
                title: Text("Oui"),
                leading: Radio(
                  value: true,
                  groupValue: isAnonymous,
                  onChanged: (bool? value) {
                    _toggleAnonymous();
                  },
                ),
              ),
              ListTile(
                title: Text("Non"),
                leading: Radio(
                  value: false,
                  groupValue: isAnonymous,
                  onChanged: (bool? value) {
                    _toggleAnonymous();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                _showThankYouMessage();
              },
            ),
          ],
        );
      },
    );
  }

  void _showThankYouMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Merci !"),
          content: Text(isAnonymous
              ? "Merci d'avoir répondu anonymement !"
              : "Merci d'avoir répondu !"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  ratings.clear();
                  currentQuestionIndex = 0;
                  isAnonymous = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire QVT'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              questions[currentQuestionIndex],
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          RatingBar.builder(
            initialRating: currentRating ?? 0.0,
            minRating: 1,
            maxRating: 5,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 36.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: _answerQuestion,
          ),
          if (currentRating != null)
            ElevatedButton(
              child: Text("Suivant"),
              onPressed: _nextQuestion,
            ),
        ],
      ),
    );
  }
}
