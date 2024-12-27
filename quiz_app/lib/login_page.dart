import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fa21-bcs-130-default-rtdb.firebaseio.com/",
  ).ref('UserInfo');

  Future<void> _authenticateUser() async {
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;
    try {
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        bool isAuthenticated = false;

        debugPrint("${snapshot.value}");
        data.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            String storedEmail = '';
            String storedPassword = '';

            for (String userInfo in value) {
              if (userInfo.startsWith("Email:")) {
                storedEmail = userInfo.replaceFirst("Email:", "").trim();
              } else if (userInfo.startsWith("Password:")) {
                storedPassword = userInfo.replaceFirst("Password:", "").trim();
              }
            }
            debugPrint("Stored Email: $storedEmail");
            debugPrint("Stored Password: $storedPassword");
            if (storedEmail == enteredEmail &&
                storedPassword == enteredPassword) {
              isAuthenticated = true;
            }
          }
        });

        if (isAuthenticated) {
          debugPrint("Login Successful");
        } else {
          debugPrint("Invalid Credentials");
        }
      } else {}
    } catch (e) {
      debugPrint("Error authenticating user: $e");
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Enter your email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _passwordController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Enter your password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _authenticateUser();
                  }
                },
                child: Text("Login"),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
