import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDetailScreen extends StatefulWidget {
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
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  // Function to send messages
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Get the current user's ID
      String userId = _auth.currentUser!.uid;

      // Store the message under the user's ID
      _firestore.collection('chat').doc(userId).collection('messages').add({
        'userName': widget.userName,
        'phoneNumber': widget.phoneNumber,
        'latestMessage': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isActive': widget.isActive,
      });

      // Clear the message input field
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // This can be replaced with your message list widget
              child: StreamBuilder(
                stream: _firestore
                    .collection('chat')
                    .doc(_auth.currentUser!.uid)  // Fetch messages for the current user
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(message['latestMessage']),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Call the send message function
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
