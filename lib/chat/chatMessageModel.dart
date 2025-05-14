import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final String senderUID;
  final String senderRole;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.senderUID,
    required this.senderRole,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      senderUID: map['senderUID'] ?? '',
      senderRole: map['senderRole'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
