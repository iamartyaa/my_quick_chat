import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({
    super.key,
    required this.friendId,
  });
  final String friendId;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    // final user = FirebaseAuth.instance.currentUser;
    final auth = FirebaseAuth.instance;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    final timeStamp = DateTime.now();
    // print(widget.friendId+ 'hehehehe');
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('friends')
        .doc(widget.friendId)
        .collection('chat')
        .add({
      'text': _enteredMessage,
      'createdAt': timeStamp,
      'userId': auth.currentUser!.uid,
      'username': userData['username'],
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendId)
        .collection('friends')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .add({
      'text': _enteredMessage,
      'createdAt': timeStamp,
      'userId': auth.currentUser!.uid,
      'username': userData['username'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.emoji_emotions_outlined,
          color: Colors.grey[500],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Type your message...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            onChanged: (val) {
              setState(() {
                _enteredMessage = val;
              });
            },
            controller: _controller,
          ),
        ),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty
              ? null
              : () {
                  _sendMessage();
                },
          icon: const Icon(Icons.send),
          color: MyTheme.kkAccentColor,
        ),
      ],
    );
  }
}
