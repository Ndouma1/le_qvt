import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:le_qvt/pages/models/question.dart';
import 'package:le_qvt/pages/models/response.dart';

class ConsulterStatistiquePage extends StatefulWidget {
  final List<Question> questions;
  final List<Response> responses;

  const ConsulterStatistiquePage(
      {super.key, required this.questions, required this.responses});

  @override
  _ConsulterStatistiquePageState createState() =>
      _ConsulterStatistiquePageState();
}

class _ConsulterStatistiquePageState extends State<ConsulterStatistiquePage> {
  List<charts.Series> _seriesList = [];

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  void _generateChartData() {
    // Liste pour stocker les données de chaque question
    List<List<StatData>> questionDataList = [];

    // Parcourir chaque question
    for (var question in widget.questions) {
      // Liste pour stocker les données de chaque réponse
      List<StatData> responseList = [];

      // Parcourir chaque réponse
      for (var response in widget.responses) {
        // Vérifier si la réponse correspond à la question en cours
        if (response.questionId == question.id) {
          // Créer une instance de StatData avec la réponse et son compteur
          StatData data = StatData(response.value, response.counter);
          responseList.add(data);
        }
      }

      // Ajouter la liste de données de réponse à la liste de données de question
      questionDataList.add(responseList);
    }

    // Générer les séries de données pour chaque question
    List<charts.Series<StatData, String>> seriesList = [];
    for (var i = 0; i < questionDataList.length; i++) {
      // Créer une série de données avec les données de la question
      charts.Series<StatData, String> series = charts.Series(
        id: widget.questions[i].id,
        domainFn: (StatData data, _) => data.value,
        measureFn: (StatData data, _) => data.counter,
        data: questionDataList[i],
      );

      // Ajouter la série à la liste des séries
      seriesList.add(series);
    }

    setState(() {
      _seriesList = seriesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.questions.length,
          itemBuilder: (BuildContext context, int index) {
            Question question = widget.questions[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 200.0,
                      child: charts.BarChart(
                        _seriesList[index]
                            as List<charts.Series<dynamic, String>>,
                        animate: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StatData {
  final String value;
  final int counter;

  StatData(this.value, this.counter);
}
