import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'chatdetail.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestContactPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      await Permission.contacts.request();
    }
  }

  Future<List<Contact>> getPhoneContacts() async {
    await requestContactPermission(); // Request permission before accessing contacts
    return await ContactsService.getContacts();
  }

  Future<List<Contact>> getRegisteredContacts() async {
    // Get all phone contacts
    List<Contact> phoneContacts = await getPhoneContacts();

    // Get registered users from Firebase
    QuerySnapshot userSnapshot = await _firestore.collection('users').get();

    // Get phone numbers from Firebase users
    List<String> registeredPhoneNumbers = userSnapshot.docs.map((doc) {
      return doc['phoneNumber'].toString(); // Assuming phoneNumber is stored as a string
    }).toList();

    // Filter contacts that are registered in the app
    List<Contact> registeredContacts = phoneContacts.where((contact) {
      return contact.phones!.any((phone) => registeredPhoneNumbers.contains(phone.value));
    }).toList();

    return registeredContacts;
  }

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
            icon: Icon(Icons.add, color: Colors.white),  // New Message button
            onPressed: () async {
              // Show all contacts saved in the phone and check Firebase
              List<Contact> registeredContacts = await getRegisteredContacts();

              // Show them in a new screen
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: registeredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = registeredContacts[index];
                        return ListTile(
                          title: Text(contact.displayName ?? 'Unknown'),
                          subtitle: Text(contact.phones!.isNotEmpty
                              ? contact.phones!.first.value ?? 'No number'
                              : 'No number'),
                          onTap: () {
                            // Open a chat with this user
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  userName: contact.displayName ?? 'Unknown',
                                  phoneNumber: contact.phones!.isNotEmpty
                                      ? contact.phones!.first.value ?? 'No number'
                                      : 'No number',
                                  isActive: true,
                                  latestMessage: '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('chats').snapshots(),  // Fetch chats from Firebase
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Ensure snapshot.data is not null
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No chats available', style: TextStyle(color: Colors.white)),
            );
          }

          var chats = snapshot.data!.docs;  // Safely accessing the 'docs' property

          // Sort chats by timestamp (latest at the top)
          chats.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

          // Get the top 3 recent chats
          var recentChats = chats.take(3).toList();

          return Container(
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
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentChats.length,
                    itemBuilder: (context, index) {
                      final chat = recentChats[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                userName: chat['userName'],
                                phoneNumber: chat['phoneNumber'],
                                isActive: chat['isActive'],
                                latestMessage: chat['latestMessage'],
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
                              Text(
                                chat['phoneNumber'],  // Show phone number
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
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
                          chat['latestMessage'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          chat['timestamp'] != null
                              ? (chat['timestamp'] as Timestamp).toDate().toString()
                              : '',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                userName: chat['userName'],
                                phoneNumber: chat['phoneNumber'],
                                isActive: chat['isActive'],
                                latestMessage: chat['latestMessage'],
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
          );
        },
      ),
    );
  }
}
