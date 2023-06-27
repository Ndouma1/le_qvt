import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatelessWidget {
  final List<int> ratings;

  const StatsPage({super.key, required this.ratings});

  List<charts.Series<RatingData, String>> _createChartData() {
    final data = [
      RatingData('Mauvais', ratings[0]),
      RatingData('Équilibré', ratings[1]),
      RatingData('Très bien', ratings[2]),
      // Ajoutez plus de données en fonction de vos questions
    ];

    return [
      charts.Series<RatingData, String>(
        id: 'Ratings',
        domainFn: (RatingData rating, _) => rating.question,
        measureFn: (RatingData rating, _) => rating.rating,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques QVT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Tendances de la qualité de vie au travail',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: charts.BarChart(
                _createChartData(),
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingData {
  final String question;
  final int rating;

  RatingData(this.question, this.rating);
}
