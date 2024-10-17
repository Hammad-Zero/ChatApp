import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userName;
  final bool isActive;

  ChatDetailScreen({required this.userName, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
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
                if (isActive)
                  Text(
                    'Active',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                  )
                else
                  Text(
                    'Offline',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {
              // Handle call button press
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () {
              // Handle camera button press
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFF), Color(0xFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  buildMessage(
                    message: 'Hey, what\'s up?',
                    isReceived: true,
                    time: 'Today',
                  ),
                  buildMessage(
                    message: 'Not much, just hanging out at home. How about you?',
                    isReceived: false,
                    time: 'Today',
                  ),
                  buildMessage(
                    message: 'Same here. I\'ve been trying to stay busy by working on some art projects.',
                    isReceived: true,
                    time: 'Today',
                  ),
                  buildMessage(
                    message: 'That sounds cool. What kind of art are you into?',
                    isReceived: false,
                    time: 'Today',
                  ),
                  buildMessage(
                    message: 'I like to do a lot of different things, but right now I\'m really into painting. I\'ve been working on a series of abstract landscapes.',
                    isReceived: true,
                    time: 'Today',
                  ),
                ],
              ),
            ),
            buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget buildMessage({required String message, required bool isReceived, required String time}) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isReceived ? Colors.grey[800] : Color(0xFF8B4DFF),
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(maxWidth: 250),
        child: Column(
          crossAxisAlignment:
          isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attachment, color: Colors.white),
            onPressed: () {
              // Handle attachment button press
            },
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF8B4DFF)),
            onPressed: () {
              // Handle send button press
            },
          ),
        ],
      ),
    );
  }
}