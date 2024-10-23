import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final bool isActive;
  final String latestMessage;

  ChatDetailScreen({
    required this.userName,
    required this.phoneNumber,
    required this.isActive,
    required this.latestMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Display chat header with user details
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[850],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.face, color: Colors.white),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      phoneNumber,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      isActive ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Display the latest message
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Latest Message: $latestMessage",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          // Add message sending and chat display functionality here
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  "Chat history will be shown here",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
