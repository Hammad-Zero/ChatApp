import 'package:chatapp/messagelist.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
              // Heading Text
              const Text(
                'Hello, Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle Text
              Text(
                'Happy to see you again, to use your account please login first.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Image.asset('assets/images/talk.jpeg', width: 300,height: 300, alignment: Alignment.center,),

              // Phone Number Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle OTP
                  },
                  child: const Center(
                    child:  Text(
                      'Did not received OTP?',

                      style: TextStyle(color: Colors.red,),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ChatScreen()),
                    );
                                      },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Or Login with Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Text('Or Login with'),
              //     ),
              //     Expanded(
              //       child: Divider(
              //         thickness: 1,
              //         color: Colors.grey[400],
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 16),

              // Social Media Icons Row
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       icon: Image.asset('assets/icons/google.png'),
              //       iconSize: 40,
              //       onPressed: () {
              //         // Handle Google login
              //       },
              //     ),
              //     // SizedBox(width: 16),
              //     // IconButton(
              //     //   icon: Image.asset('assets/icons/apple.png'),
              //     //   iconSize: 40,
              //     //   onPressed: () {
              //     //     // Handle Apple login
              //     //   },
              //     // ),
              //     // SizedBox(width: 16),
              //     // IconButton(
              //     //   icon: Image.asset('assets/icons/facebook.png'),
              //     //   iconSize: 40,
              //     //   onPressed: () {
              //     //     // Handle Facebook login
              //     //   },
              //     // ),
              //   ],
              // ),
            ],
          ),
  ],
        ),
        ),
      ),
    );
  }
}