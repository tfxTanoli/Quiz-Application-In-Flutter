import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/Result.dart';
import 'firebase_options.dart';
import 'signup_page.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // White button text
            backgroundColor: Color(0xFF00796B), // Dark teal button background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.white,
        ),
      ),
      home: SignupPage(),
    );
  }
}

class AddQuestionForm extends StatefulWidget {
  @override
  _AddQuestionFormState createState() => _AddQuestionFormState();
}

class _AddQuestionFormState extends State<AddQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _questionController = TextEditingController();
  TextEditingController _optionAController = TextEditingController();
  TextEditingController _optionBController = TextEditingController();
  TextEditingController _optionCController = TextEditingController();
  TextEditingController _optionDController = TextEditingController();
  TextEditingController _correctAnswerController = TextEditingController();

  Future<void> _saveQuestion() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _firestore.collection('questions').add({
          'question': _questionController.text,
          'options': [
            _optionAController.text,
            _optionBController.text,
            _optionCController.text,
            _optionDController.text,
          ],
          'correct_answer': _correctAnswerController.text,
        });

        _questionController.clear();
        _optionAController.clear();
        _optionBController.clear();
        _optionCController.clear();
        _optionDController.clear();
        _correctAnswerController.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Question Added Successfully!"),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error adding question: $e"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Question"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _questionController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "Type your question here",
                          hintStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _optionAController,
                      decoration: InputDecoration(
                        hintText: "Option A",
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Option A';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _optionBController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Option B",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Option B';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _optionCController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Option C",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Option C';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _optionDController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Option D",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Option D';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _correctAnswerController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Correct Answer",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please specify the correct answer';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveQuestion,
                      child: const Text("Add Question"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
                child: const Text("Start Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String? username;
  QuizScreen({this.username});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _currentQuestion;
  List<dynamic>? _options;
  bool _isLoading = true;
  String? _selectedOption;
  Set<String> _shownQuestionIds = {};
  List<Map<String, dynamic>> _results = [];
  int _questionCounter = 0;
  int correctQuestionCounter =
      0; // Counter for the number of questions answered
  final int _totalQuestions = 10; // Limit to 10 questions

  Future<void> _getRandomQuestion() async {
    if (_questionCounter >= _totalQuestions) {
      // If all questions have been answered, navigate to ResultPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            results: _results,
            username: widget.username,
            correctanswers: correctQuestionCounter,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _selectedOption = null;
    });

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('questions').get();

      if (querySnapshot.docs.isNotEmpty) {
        List<QueryDocumentSnapshot> availableQuestions = querySnapshot.docs
            .where((doc) => !_shownQuestionIds.contains(doc.id))
            .toList();

        if (availableQuestions.isEmpty) {
          setState(() {
            _currentQuestion = null;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No more questions available."),
          ));
          return;
        }

        Random random = Random();
        int randomIndex = random.nextInt(availableQuestions.length);
        QueryDocumentSnapshot selectedQuestion =
            availableQuestions[randomIndex];

        setState(() {
          _currentQuestion = selectedQuestion.data() as Map<String, dynamic>;
          _options = _currentQuestion?['options'];
          _shownQuestionIds.add(selectedQuestion.id);
          _isLoading = false;
        });
      } else {
        setState(() {
          _currentQuestion = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No questions available in the database."),
        ));
      }
    } catch (e) {
      setState(() {
        _currentQuestion = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching questions: $e"),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _getRandomQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Username ${widget.username}',
                style: TextStyle(color: Colors.white)), // Left-aligned username
            Text('Quiz (${_questionCounter + 1}/$_totalQuestions)',
                style: TextStyle(
                    color: Colors.white)), // Right-aligned question progress
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                    results: _results,
                    username: widget.username,
                    correctanswers: correctQuestionCounter,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentQuestion == null
              ? Center(
                  child: Text(
                    "No more questions available.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _currentQuestion?['question'] ?? "Unknown question",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      if (_options != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            _options!.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                width: double.infinity,
                                constraints: BoxConstraints(maxWidth: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                  color: Colors.white,
                                  child: RadioListTile<String>(
                                    title: Text(
                                      _options![index],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    value: _options![index],
                                    groupValue: _selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                    activeColor: Color(0xFF4CAF50),
                                    tileColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedOption == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please select an option."),
                            ));
                          } else {
                            bool isCorrect = _selectedOption ==
                                _currentQuestion?['correct_answer'];

                            if (isCorrect) {
                              correctQuestionCounter++; // Increment if the answer is correct
                            }

                            _results.add({
                              'question': _currentQuestion?['question'],
                              'selected': _selectedOption,
                              'correctAnswer':
                                  _currentQuestion?['correct_answer'],
                              'isCorrect': isCorrect,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                isCorrect
                                    ? "Correct!"
                                    : "Wrong! The correct answer is ${_currentQuestion?['correct_answer']}.",
                              ),
                            ));

                            setState(() {
                              _questionCounter++;
                            });

                            _getRandomQuestion();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF00796B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
