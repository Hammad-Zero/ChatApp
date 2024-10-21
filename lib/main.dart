import 'package:chatapp/spalsh.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home:  spalsh(),
    );
  }
}
