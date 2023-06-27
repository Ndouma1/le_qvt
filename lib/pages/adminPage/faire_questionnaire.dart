import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:le_qvt/pages/adminPage/ListeQuestionnairesPage.dart';

class FaireQuestionnaire extends StatefulWidget {
  const FaireQuestionnaire({Key? key}) : super(key: key);

  @override
  _FaireQuestionnaireState createState() => _FaireQuestionnaireState();
}

class _FaireQuestionnaireState extends State<FaireQuestionnaire> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateLimiteController = TextEditingController();
  final TextEditingController _groupesController = TextEditingController();

  List<Question> _questions = [];
  final TextEditingController _nouvelleQuestionController =
      TextEditingController();

  void _ajouterQuestion() {
    final String nouvelleQuestionTexte = _nouvelleQuestionController.text;
    if (nouvelleQuestionTexte.isNotEmpty) {
      setState(() {
        _questions.add(Question(nouvelleQuestionTexte));
        _nouvelleQuestionController.clear();
      });
    }
  }

  void _publierQuestionnaire() {
    // Créez une référence à la collection "Questionnaires"
    CollectionReference questionnairesCollection =
        FirebaseFirestore.instance.collection('Questionnaires');

    // Créez un nouveau document pour le questionnaire
    DocumentReference newQuestionnaireRef = questionnairesCollection.doc();

    // Créez un objet Map avec les données du questionnaire
    Map<String, dynamic> questionnaireData = {
      'titre': _titreController.text,
      'description': _descriptionController.text,
      'dateLimiteReponse': _dateLimiteController.text,
      'groupesCibles':
          _groupesController.text.split(',').map((e) => e.trim()).toList(),
    };

    // Enregistrez le questionnaire dans Firestore
    newQuestionnaireRef.set(questionnaireData).then((value) {
      // Enregistrement réussi

      // Enregistrez les questions dans la sous-collection "Questions" du questionnaire
      for (Question question in _questions) {
        newQuestionnaireRef.collection('Questions').add({
          'texteQuestion': question.text,
        });
      }

      // Affichez une boîte de dialogue ou effectuez toute autre action nécessaire
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Questionnaire publié'),
            content: const Text('Le questionnaire a été publié avec succès.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetQuestionnaire();
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Erreur lors de l'enregistrement
      print('Erreur lors de l\'enregistrement du questionnaire: $error');
    });
  }

  void _resetQuestionnaire() {
    _titreController.clear();
    _descriptionController.clear();
    _dateLimiteController.clear();
    _groupesController.clear();
    _nouvelleQuestionController.clear();
    setState(() {
      _questions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faire un questionnaire'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListeQuestionnairesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Détails du questionnaire',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _dateLimiteController,
              decoration: const InputDecoration(
                labelText: 'Date limite de réponse',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _groupesController,
              decoration: const InputDecoration(
                labelText:
                    'Groupes d\'employés cibles (séparés par des virgules)',
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Questions',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_questions[index].text),
                );
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nouvelleQuestionController,
              decoration: const InputDecoration(
                labelText: 'Nouvelle question',
              ),
              onSubmitted: (_) => _ajouterQuestion(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterQuestion,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: _resetQuestionnaire,
                child: const Text('Réinitialiser'),
              ),
              ElevatedButton(
                onPressed: _publierQuestionnaire,
                child: const Text('Publier le questionnaire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final String text;

  Question(this.text);
}
