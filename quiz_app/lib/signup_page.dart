import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/login_page.dart';
import 'package:quiz_app/main.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignupPage(),
      theme: ThemeData.dark(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final databaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: "https://fa21-bcs-130-default-rtdb.firebaseio.com/")
      .ref('UserInfo');
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> checkAndSignupUser() async {
    String enteredEmail = email.text.trim();

    // Fetch data from the database to check if the email already exists
    final snapshot = await databaseRef.get();
    var data = snapshot.value;

    if (data != null && data is Map) {
      bool emailExists = false;

      // Check if entered email matches any existing email
      data.forEach((key, value) {
        if (value is Map && value['Email'] == enteredEmail) {
          emailExists = true;
        }
      });

      if (emailExists) {
        debugPrint("This email is already registered. Signup failed.");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email is already registered."),
          backgroundColor: Colors.red,
        ));
        return;
      }
    }

    // If email does not exist, proceed with signup
    if (password.text.toString().length > 10 &&
        email.text.toString().contains('@gmail.com') &&
        email.text.toString().length > 8) {
      databaseRef.push().set({
        'Name': name.text.toString(),
        'Email': email.text.toString(),
        'Password': password.text.toString(),
      }).then((_) {
        debugPrint("Signup Successful");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(username: name.text.toString()),
          ),
        );
      }).onError((error, StackTrace) {
        debugPrint('Error: $error');
      });
    } else if (email.text.toString().length == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fill the Email field')));
    } else if (name.text.toString().length == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fill the Name field')));
    } else if (password.text.toString().length == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please set password')));
    } else {
      debugPrint("Invalid data. Signup failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Signup Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: name,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Enter your name",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: email,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: password,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 70),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: checkAndSignupUser,
                  child: const Text("Signup"),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
