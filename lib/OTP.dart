import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure Firestore is imported
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'messagelist.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String username;
  final bool isSigningUp;

  OtpScreen({
    required this.verificationId,
    required this.phoneNumber,
    required this.username,
    required this.isSigningUp,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  bool _isVerifying = false;

  void _verifyOtp() async {
    setState(() {
      _isVerifying = true; // Show loader during verification
    });

    String otp = _otpController.text.trim();
    try {
      // Create PhoneAuthCredential with the provided OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // OTP verified successfully
      if (widget.isSigningUp) {
        // Store user details in Firestore
        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'username': widget.username,
          'phoneNumber': widget.phoneNumber,
        });

        // Show a success alert for signup
        _showSignupSuccessDialog();
      } else {
        // Navigate to ChatScreen if logging in
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
              (route) => false, // Remove all previous screens
        );
      }
    } catch (e) {
      // Handle OTP verification failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verification failed. Please try again.")),
      );
    } finally {
      // Ensure the loading state is reset
      setState(() {
        _isVerifying = false; // Hide loader if verification fails or succeeds
      });
    }
  }

  // Show Alert Dialog after successful signup
  void _showSignupSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Signup Successful"),
          content: Text("Thanks for Signing up, Let's Chat!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                // Navigate to LoginScreen after dismissing the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false, // Remove all previous screens
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the OTP sent to ${widget.phoneNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            Center(
              child: _isVerifying
                  ? CircularProgressIndicator() // Show loader during verification
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _verifyOtp,
                child: Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
