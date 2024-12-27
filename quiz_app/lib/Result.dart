import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final String? username;
  final int? correctanswers;

  ResultsPage(
      {required this.results,
      required this.username,
      required this.correctanswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: results.isEmpty
          ? Center(
              child: Text(
                "No results to show.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "$username, you answered $correctanswers out of ${results.length} questions correctly!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Quiz Results",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            result['question'] ?? "No question provided",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text("Your Answer: ${result['selected']}"),
                              Text(
                                  "Correct Answer: ${result['correctAnswer']}"),
                              if (result['isCorrect'])
                                Text(
                                  "You answered correctly!",
                                  style: TextStyle(color: Colors.green),
                                )
                              else
                                Text(
                                  "Your answer was wrong.",
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                          trailing: Icon(
                            result['isCorrect']
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                result['isCorrect'] ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
