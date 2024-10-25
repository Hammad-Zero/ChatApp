import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'messagelist.dart'; // Import Firestore

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneNumberController.text.trim();
      String username = _usernameController.text.trim();

      // Create a new user in Firebase Authentication
      try {
        UserCredential userCredential = await _auth.signInAnonymously(); // Sign in anonymously to get User ID
        String userId = userCredential.user!.uid; // Get User ID

        // Store user information in Firestore
        await _firestore.collection('Users').doc(userId).set({
          'username': username,
          'phone_number': phoneNumber,
          'user_id': userId,
        });

        // Navigate to ChatScreen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign up failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 70),
                Image.asset("assets/images/talk.jpeg"),
                const SizedBox(height: 20),
                Text("Let's Chat Together ! ", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),),
                const SizedBox(height: 35),

                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) => value!.isEmpty ? "Please enter a username" : null,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "+92 3XX XXXXXXX",
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
