import 'package:flutter/material.dart';
import 'package:quiz_app/main.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> authenticateUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == "admin@gmail.com" && password == "administrator") {
      // Navigate to AddQuestionForm for admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddQuestionForm()),
      );
    } else if (email == "usman5194999@gmail.com" && password == "tfxUsman124") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QuizScreen(username: "Muhammad Usman")));
    } else if (email == 'sajalal678@gmail.com' && password == 'sajalali123') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QuizScreen(username: "Sajal Ali")));
    } else {
      // For non-admin, show an error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email or password!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authenticateUser,
              child: const Text("Login"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
