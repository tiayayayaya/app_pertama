import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send a new chat message
  static Future<void> sendMessage(String text) async {
    final user = _auth.currentUser;
    if (user == null || text.trim().isEmpty) return;

    // Fetch user's role from Firestore
    final userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    final role = userDoc.data()?['role'] ?? 'buyer';

    final messageData = {
      'text': text.trim(),
      'senderUID': user.uid,
      'senderRole': role,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final globalChatRef =
        _firestore.collection('buyer_seller_global').doc('global_chat');

    // Set metadata for latest message
    await globalChatRef.set({
      'lastMessage': text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
      if (role == 'buyer') 'lastReadByBuyer': FieldValue.serverTimestamp(),
      if (role == 'seller') 'lastReadBySeller': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Add actual message to subcollection
    await globalChatRef.collection('messages').add(messageData);
  }

  /// Stream all messages in order (oldest → newest)
  static Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection('buyer_seller_global')
        .doc('global_chat')
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
