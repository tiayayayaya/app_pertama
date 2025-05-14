
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kostgo/chat/chatPage1.dart';


class ChatDetailPage1 extends StatefulWidget {
  @override
  _ChatDetailPageState1 createState() => _ChatDetailPageState1();
}

class _ChatDetailPageState1 extends State<ChatDetailPage1> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> messages = [];
  String? uid;
  String? role;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid;
    _loadUserRole().then((_) {
      _listenToMessages();
    });
  }

  Future<void> _loadUserRole() async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    role = userDoc.data()?['role'] ?? 'buyer';
  }

  void _listenToMessages() {
    _firestore
        .collection('buyer_seller_global')
        .doc('global_chat')
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        messages = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || uid == null || role == null) return;

    setState(() {
      _isSending = true;
    });

    try {
      final messageData = {
        'text': text,
        'senderUID': uid,
        'senderRole': role,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final chatDocRef =
          _firestore.collection('buyer_seller_global').doc('global_chat');

      // Update last message metadata
      await chatDocRef.set({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        if (role == 'buyer') 'lastReadByBuyer': FieldValue.serverTimestamp(),
        if (role == 'seller') 'lastReadBySeller': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Add to messages subcollection
      await chatDocRef.collection('messages').add(messageData);

      _messageController.clear();
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _showTopSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = screenHeight / 6;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(animation1),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    
                    child: Container(
                      height: panelHeight,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Image.asset('images/logo.png'),
                                      title: const Text('Pusat Bantuan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  0, 45, 95, 1))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Container(
                                height: 5,
                                width: 30,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 215, 209, 209),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUID = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 2),
                const CircleAvatar(
                  backgroundImage: AssetImage("images/avatarmuara.png"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Pelanggan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 70),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['senderUID'] == currentUID;

              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (isMe ? Alignment.topRight : Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (isMe
                          ? const Color.fromARGB(255, 11, 114, 42)
                          : const Color.fromARGB(255, 6, 65, 154)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      msg['text'] ?? '',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 20),
                                    child: InkWell(
                                      
                                      child: const Row(
                                        children: [
                                          Icon(Icons.image),
                                          SizedBox(width: 10),
                                          Text('Gambar'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22),
                                    child: Container(
                                      height: 5,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black,
                              spreadRadius: 2,
                              blurRadius: 0,
                              offset: Offset(0, 0)),
                        ],
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.black, size: 20),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: _isSending ? null : _sendMessage,
                    child: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : const Icon(Icons.send, color: Colors.white, size: 18),
                    backgroundColor: const Color.fromARGB(255, 6, 65, 154),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}