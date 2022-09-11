import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/app_theme.dart';
import 'package:quick_chat/screens/chat/chat_room.dart';

class SelectContactScreen extends StatefulWidget {
  static const routeName = '/select-contact';
  const SelectContactScreen({super.key});

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends'),
        elevation: 0,
        backgroundColor: MyTheme.kkPrimaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('friends')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          // final myUser = chatDocs
          //     .firstWhere((element) => element.id == auth.currentUser!.uid);

          // print(myUser['username']);
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            // shrinkWrap: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = chatDocs[index];

              return GestureDetector(
                onTap: () {
                  // Navigator.of(context)
                  //     .popAndPushNamed(ChatRoom.routeName, arguments: {
                  //   'id': data.id,
                  //   'name': data['friendName'],
                  // });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(
                          friendID: data.id, friendName: data['friendName']),
                    ),
                  );
                  
                },
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: MyTheme.kkAccentColor,
                      child: const Icon(
                        Icons.account_circle_sharp,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      data['friendName'],
                      style: MyTheme.fieldTitle.copyWith(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
