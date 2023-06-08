import 'package:flutter/material.dart';
import 'package:le_qvt/pages/QuestionPage/question_page.dart';
import 'package:le_qvt/pages/bottomNavigation/bottom_navigation.dart';

//i

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Résultats du dernier questionnaire',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuestionPage()),
                  );
                },
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Questionnaire du jour',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
