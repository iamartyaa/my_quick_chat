import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/screens/chat/chat_room.dart';

import '../../../app_theme.dart';

class Chats extends StatelessWidget {
  final Color kkPrimaryColor = MyTheme.kkPrimaryColor;
  final auth = FirebaseAuth.instance;

  Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Row(
            children: [
              Text(
                'Recent Chats',
                style: MyTheme.heading2,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: kkPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
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

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = chatDocs[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                              friendID: data.id,
                              friendName: data['friendName']),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: MyTheme.kkAccentColor,
                            child: const Icon(
                              Icons.account_circle_sharp,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['friendName'],
                                style: MyTheme.heading2.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'random recent text',
                                style: MyTheme.bodyText1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
