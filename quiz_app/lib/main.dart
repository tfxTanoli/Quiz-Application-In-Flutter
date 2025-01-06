import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/Result.dart';
import 'firebase_options.dart';
import 'signup_page.dart';
import 'dart:math';
import 'dart:async';

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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.black),
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
  int correctQuestionCounter = 0;
  final int _totalQuestions = 10;
  int _remainingTime = 15;
  Timer? _timer;
  double percentage = 0.0;
  String? status;

  Future<void> _getRandomQuestion() async {
    if (_questionCounter >= _totalQuestions) {
      if (percentage >= 50) {
        status = 'Pass';
      } else {
        status = 'Fail';
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
              results: _results,
              username: widget.username,
              correctanswers: correctQuestionCounter,
              percentage: percentage,
              status: status),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _selectedOption = null;
      _remainingTime = 15;
    });

    _startTimer();

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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Time's up! The correct answer is ${_currentQuestion?['correct_answer']}.",
      ),
    ));

    _results.add({
      'question': _currentQuestion?['question'],
      'selected': null,
      'correctAnswer': _currentQuestion?['correct_answer'],
      'isCorrect': false,
    });

    setState(() {
      _questionCounter++;
    });

    _getRandomQuestion();
  }

  @override
  void initState() {
    super.initState();
    _getRandomQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.username}', style: TextStyle(color: Colors.white)),
            Text('Quiz (${_questionCounter + 1}/$_totalQuestions)',
                style: TextStyle(color: Colors.white)),
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
                      percentage: percentage,
                      status: status),
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
                          color: Colors.white,
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
                      Text(
                        "Time Remaining: $_remainingTime seconds",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),
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
                              correctQuestionCounter++;
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
                              if (_questionCounter >= 10) {
                                percentage =
                                    (correctQuestionCounter / 10) * 100;
                              }
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



