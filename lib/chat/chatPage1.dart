import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatDetailPage1.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buyer_seller_global')
            .doc('global_chat')
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          final lastMessage = data?['lastMessage'] ?? 'Mulai chat...';
          final lastTime = (data?['lastMessageTime'] as Timestamp?)?.toDate();
          final timeText = lastTime != null
              ? "${lastTime.hour.toString().padLeft(2, '0')}:${lastTime.minute.toString().padLeft(2, '0')}"
              : '';

          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/avatarmuara.png'),
              radius: 30,
            ),
            title: const Text("Global Chat"),
            subtitle: Text(lastMessage),
            trailing: Text(timeText),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatDetailPage()),
            ),
          );
        },
      ),
    );
  }
}
