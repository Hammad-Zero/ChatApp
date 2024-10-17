import 'package:flutter/material.dart';

import 'chatdetail.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recentChats = [
    {'userName': 'Harper', 'isActive': true, 'message': 'Hey, what\'s up?', 'time': '4 min'},
    {'userName': 'Isabelle', 'isActive': false, 'message': 'That sounds cool. What...', 'time': '35 min'},
    {'userName': 'Alexander', 'isActive': true, 'message': 'I like to do a lot of different...', 'time': '39 min'},
    // Add more recent chats here
  ];

  final List<Map<String, dynamic>> allChats = [
    {'userName': 'Olivia', 'isActive': false, 'message': 'I\'ll see you tomorrow!', 'time': '1 hr'},
    {'userName': 'Sophia', 'isActive': false, 'message': 'Can you send the files?', 'time': '2 hrs'},
    {'userName': 'Liam', 'isActive': true, 'message': 'I\'m on my way!', 'time': '3 hrs'},
    // Add more chats for full list
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Recent chats heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent Chats',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            // Recent chats list
            Container(
              height: 100,  // Height for recent chats section
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentChats.length,
                itemBuilder: (context, index) {
                  final chat = recentChats[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ChatDetailScreen when a recent chat is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            userName: chat['userName'],
                            isActive: chat['isActive'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.face, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            chat['userName'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Divider between recent chats and all chats
            Divider(color: Colors.grey[700], thickness: 1, indent: 16, endIndent: 16),
            // All chats heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All Chats',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            // All chats list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: allChats.length,
                itemBuilder: (context, index) {
                  final chat = allChats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.face, color: Colors.white),
                    ),
                    title: Text(
                      chat['userName'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      chat['message'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      chat['time'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Navigate to ChatDetailScreen when a chat is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            userName: chat['userName'],
                            isActive: chat['isActive'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}