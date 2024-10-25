import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OTP.dart';
import 'signup.dart'; // Import Signup screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  bool _isLoading = false; // Loading state

  void _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();
    String username = _usernameController.text.trim();

    // Validate input
    if (phoneNumber.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both username and phone number.")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    // Initiate OTP sending
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign-in for instant verification cases
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false; // Stop loading
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP verification failed. Please try again."),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save the verification ID to use later
        setState(() {
          _verificationId = verificationId;
          _isLoading = false; // Stop loading
        });

        // Navigate to OTP screen to verify the code
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              username: username,
              isSigningUp: false,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Timeout for OTP auto retrieval
        setState(() {
          _verificationId = verificationId;
          _isLoading = false; // Stop loading
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello, Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Image.asset("assets/images/talk.jpeg"),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Login Button
              Center(
                child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _sendOtp,
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 6),
              Center(child: Text("or", style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),)),
              const SizedBox(height: 1),

              // Signup Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to Signup Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
